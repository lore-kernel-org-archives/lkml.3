Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaBROvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:51:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44028 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaBROvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:51:20 -0500
Date: Tue, 18 Feb 2014 09:50:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, x86@kernel.org,
        linux-kbuild@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        rusty@rustcorp.com.au
Subject: Re: [PATCH 19/20] lto, module: Warn about modules that are not fully
 LTOed
Message-ID: <20140218145039.GA5339@phenom.dumpdata.com>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
 <1392733738-8290-20-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392733738-8290-20-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 03:28:57PM +0100, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When __gnu_lto_* is present that means that the module hasn't run with
> LTO yet.

The title says 'warn' but this is not a warning just information.

Can you actually build modules against the kernel with different compiler
options? I thought it would complain when trying to load about some
form of mismatch?

> 
> Cc: rusty@rustcorp.com.au
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/module.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index b99e801..4f3eff7 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1949,8 +1949,11 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  		switch (sym[i].st_shndx) {
>  		case SHN_COMMON:
>  			/* Ignore common symbols */
> -			if (!strncmp(name, "__gnu_lto", 9))
> +			if (!strncmp(name, "__gnu_lto", 9)) {
> +				pr_info("%s: module not link time optimized\n",
> +				       mod->name);
>  				break;
> +			}
>  
>  			/* We compiled with -fno-common.  These are not
>  			   supposed to happen.  */
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
