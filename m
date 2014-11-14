Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161885AbaKNUG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:06:57 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:38347 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161865AbaKNUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141114052239.GB7964@moniac.lan.yath.de>
References: <CA+r1ZhjO=kxcyjRb3=d7ozZ_VT9a+iCUy27zPZ2WGVMMzP6OVA@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3292CD43@ORSMSX114.amr.corp.intel.com>
	<CAGXu5jLsd3G3+PCwFSUGDxxbfnJwx8G8X4chH0WK21-kv+_ecA@mail.gmail.com>
	<20141114050934.GA7964@moniac.lan.yath.de>
	<20141114052239.GB7964@moniac.lan.yath.de>
Date: Fri, 14 Nov 2014 12:06:55 -0800
X-Google-Sender-Auth: zg8LTb2s7GbldDqSvHzc8x408f8
Message-ID: <CAGXu5jLL_kzAaP2oF6rQ1n3kLV9DM-UzVtVf2gv+-ugJPED7NQ@mail.gmail.com>
Subject: Re: [PATCH] syslog: provide stub check_syslog_permissions
From: Kees Cook <keescook@chromium.org>
To: Sebastian Schmidt <yath@yath.de>
Cc: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jim Davis <jim.epost@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 9:22 PM, Sebastian Schmidt <yath@yath.de> wrote:
> When building without CONFIG_PRINTK, we need to provide a stub
> check_syslog_permissions. As there is no way to turn on the
> dmesg_restrict sysctl without CONFIG_PRINTK, return success.
>
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Sebastian Schmidt <yath@yath.de>

I think this is correct. Without CONFIG_PRINTK, dmesg_restrict doesn't
exist. It's a bit mind-bending, but since all the logic for
capabilities, etc, is also missing, I guess "allow" (return 0) is the
right default without printk.

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  include/linux/syslog.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/linux/syslog.h b/include/linux/syslog.h
> index 9def529..13c05d1 100644
> --- a/include/linux/syslog.h
> +++ b/include/linux/syslog.h
> @@ -48,6 +48,14 @@
>  #define SYSLOG_FROM_PROC             1
>
>  int do_syslog(int type, char __user *buf, int count, bool from_file);
> +
> +#ifdef CONFIG_PRINTK
>  int check_syslog_permissions(int type, bool from_file);
> +#else
> +static int check_syslog_permissions(int type, bool from_file)
> +{
> +       return 0;
> +}
> +#endif
>
>  #endif /* _LINUX_SYSLOG_H */
> --
> 2.1.1



-- 
Kees Cook
Chrome OS Security
