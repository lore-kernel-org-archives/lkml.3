Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaFREMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 00:12:37 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:38566 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaFREMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 00:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140618001816.GK4841@wotan.suse.de>
References: <1402965464-11202-1-git-send-email-mcgrof@do-not-panic.com>
 <20140617145200.GA634@pathway.suse.cz> <20140618001816.GK4841@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 17 Jun 2014 21:12:13 -0700
X-Google-Sender-Auth: umCqR6kLZDq-S783hOzLXG_J63g
Message-ID: <CAB=NE6UOi9CuxfwoRptpYN2egS8SiRc9kCmtKn98WY=sHSGtxw@mail.gmail.com>
Subject: Re: [RFT v5h printk: allow increasing the ring buffer depending on
 the number of CPUs
To: =?UTF-8?B?UGV0ciBNbMOhZGVr?= <pmladek@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Joe Perches <joe@perches.com>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 5:18 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> @@ -828,29 +829,68 @@ void log_buf_kexec_setup(void)
>  /* requested log_buf_len from kernel cmdline */
>  static unsigned long __initdata new_log_buf_len;
>
> -/* save requested log_buf_len since it's too early to process it */
> -static int __init log_buf_len_setup(char *str)
> +/*
> + * CONFIG_LOG_BUF_SHIFT would be architecture aligned, anything > than it and
> + * a multiple of two of it upkeeps the alignment.
> + */
> +static void __init log_buf_len_align(unsigned size)
>  {
> -       unsigned size = memparse(str, &str);
> -
>         if (size)
>                 size = roundup_pow_of_two(size);
>         if (size > log_buf_len)
>                 new_log_buf_len = size;
> +}
> +
> +/* save requested log_buf_len since it's too early to process it */
> +static int __init log_buf_len_setup(char *str)
> +{
> +       unsigned size = memparse(str, &str);
> +
> +       log_buf_len_align(size);
>
>         return 0;
>  }
>  early_param("log_buf_len", log_buf_len_setup);

This could go as a separate patch first too, which would make the
addition very clean.

  Luis
