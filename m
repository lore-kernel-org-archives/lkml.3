Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbaLWW0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 17:26:44 -0500
Received: from ozlabs.org ([103.22.144.67]:48829 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaLWW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 17:26:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: Remove double spaces in module verification taint message
In-Reply-To: <1419269144-91285-1-git-send-email-marcel@holtmann.org>
References: <1419269144-91285-1-git-send-email-marcel@holtmann.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 23 Dec 2014 15:11:26 +1030
Message-ID: <8761d3t1u1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann <marcel@holtmann.org> writes:
> The warning message when loading modules with a wrong signature has
> two spaces in it:
>
> "module verification failed: signature and/or  required key missing"
>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Rather trivial, but I've applied it.

Thanks,
Rusty.

> ---
>  kernel/module.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index e52a8739361a..57f786bae64d 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3242,7 +3242,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	mod->sig_ok = info->sig_ok;
>  	if (!mod->sig_ok) {
>  		pr_notice_once("%s: module verification failed: signature "
> -			       "and/or  required key missing - tainting "
> +			       "and/or required key missing - tainting "
>  			       "kernel\n", mod->name);
>  		add_taint_module(mod, TAINT_UNSIGNED_MODULE, LOCKDEP_STILL_OK);
>  	}
> -- 
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
