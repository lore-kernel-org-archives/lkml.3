Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3H3SPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:15:51 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55498 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3H3SPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:15:49 -0400
MIME-Version: 1.0
In-Reply-To: <1377878801.559.28.camel@sakura.staff.proxad.net>
References: <1377878801.559.28.camel@sakura.staff.proxad.net>
Date: Fri, 30 Aug 2013 11:15:49 -0700
X-Google-Sender-Auth: YnHnNihO6gOf01YxKTquD2kCAEQ
Message-ID: <CAGXu5jLfHMw=sd0OBSTjJy5ffqrD8s6BsVv+4iA6=jzUG89dpw@mail.gmail.com>
Subject: Re: [PATCH] pstore/ram: (really) fix undefined usage of rounddown_pow_of_two
From: Kees Cook <keescook@chromium.org>
To: Maxime Bizon <mbizon@freebox.fr>
Cc: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 9:06 AM, Maxime Bizon <mbizon@freebox.fr> wrote:
> Previous attempt to fix was b042e47491ba5f487601b5141a3f1d8582304170
>
> Suggested use of is_power_of_2() was bogus because is_power_of_2(0) is
> false (documented behaviour).
>
> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>

Yes, excellent point. :)

Acked-by: Kees Cook <keescook@chromium.org>

Thanks,

-Kees

> ---
>  fs/pstore/ram.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index a6119f9..03325bc 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -400,11 +400,11 @@ static int ramoops_probe(struct platform_device *pdev)
>                 goto fail_out;
>         }
>
> -       if (!is_power_of_2(pdata->record_size))
> +       if (pdata->record_size && !is_power_of_2(pdata->record_size))
>                 pdata->record_size = rounddown_pow_of_two(pdata->record_size);
> -       if (!is_power_of_2(pdata->console_size))
> +       if (pdata->console_size && !is_power_of_2(pdata->console_size))
>                 pdata->console_size = rounddown_pow_of_two(pdata->console_size);
> -       if (!is_power_of_2(pdata->ftrace_size))
> +       if (pdata->ftrace_size && !is_power_of_2(pdata->ftrace_size))
>                 pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
>
>         cxt->dump_read_cnt = 0;
> --
> 1.7.9.5
>
>
> --
> Maxime
>
>



-- 
Kees Cook
Chrome OS Security
