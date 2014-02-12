Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaBMBXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:23:53 -0500
Received: from ozlabs.org ([203.10.76.45]:50886 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaBMBXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:23:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 17/17] lto, module: Warn about modules that are not fully LTOed
In-Reply-To: <1391846481-31491-17-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com> <1391846481-31491-17-git-send-email-ak@linux.intel.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 12 Feb 2014 11:43:08 +1030
Message-ID: <87wqh1f80r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:
> When __gnu_lto_* is present that means that the module hasn't run with
> LTO yet.

In practice, this means they didn't build their kernel properly, right?
It shouldn't break anything, but it seems really weird.  And how many
times will the prink fire on a single module?

Seems like a job for pr_warn?

Thanks,
Rusty.

> ---
>  kernel/module.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index b99e801..2052155 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1949,8 +1949,11 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  		switch (sym[i].st_shndx) {
>  		case SHN_COMMON:
>  			/* Ignore common symbols */
> -			if (!strncmp(name, "__gnu_lto", 9))
> +			if (!strncmp(name, "__gnu_lto", 9)) {
> +				printk("%s: module not link time optimized\n",
> +				       mod->name);
>  				break;
> +			}
>  
>  			/* We compiled with -fno-common.  These are not
>  			   supposed to happen.  */
> -- 
> 1.8.5.2
