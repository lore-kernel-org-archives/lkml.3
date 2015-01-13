Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbbAMReR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:34:17 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:45002 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbbAMReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:34:16 -0500
MIME-Version: 1.0
In-Reply-To: <1420564543-24589-1-git-send-email-salyzyn@android.com>
References: <1420564543-24589-1-git-send-email-salyzyn@android.com>
Date: Tue, 13 Jan 2015 09:34:15 -0800
X-Google-Sender-Auth: 0kHtxXF1dCgN1GtZHn08B2IU5A4
Message-ID: <CAGXu5jLT=cT=zGRqYRoKM3bXfFaDp-MYEwP=PP-7jB-FpUwU3A@mail.gmail.com>
Subject: Re: [PATCH 2/3] pstore: remove superfluous memory size check
From: Kees Cook <keescook@chromium.org>
To: Mark Salyzyn <salyzyn@android.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 9:15 AM, Mark Salyzyn <salyzyn@android.com> wrote:
> All previous checks will fail with error if memory size
> is not sufficient to register a zone, so this legacy
> check has become redundant.
>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> ---
>  fs/pstore/ram.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 8613e5b..34ed8f8 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -474,14 +474,6 @@ static int ramoops_probe(struct platform_device *pdev)
>         if (err)
>                 goto fail_init_fprz;
>
> -       if (!cxt->przs && !cxt->cprz && !cxt->fprz) {
> -               pr_err("memory size too small, minimum is %zu\n",
> -                       cxt->console_size + cxt->record_size +
> -                       cxt->ftrace_size);
> -               err = -EINVAL;
> -               goto fail_cnt;
> -       }
> -

Yup, good call. ramoops_init_przs and ramoops_init_prz do all the
checks already.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

>         cxt->pstore.data = cxt;
>         /*
>          * Console can handle any buffer size, so prefer LOG_LINE_MAX. If we
> @@ -525,7 +517,6 @@ fail_buf:
>         kfree(cxt->pstore.buf);
>  fail_clear:
>         cxt->pstore.bufsize = 0;
> -fail_cnt:
>         kfree(cxt->fprz);
>  fail_init_fprz:
>         kfree(cxt->cprz);
> --
> 2.2.0.rc0.207.ga3a616c
>



-- 
Kees Cook
Chrome OS Security
