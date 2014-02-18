Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaBROxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:53:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45462 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbaBROxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:53:22 -0500
Date: Tue, 18 Feb 2014 09:53:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, x86@kernel.org,
        linux-kbuild@vger.kernel.org, Joe Mario <jmario@redhat.com>,
        rusty@rustcorp.com.au, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/20] lto: Handle LTO common symbols in module loader
Message-ID: <20140218145303.GC5339@phenom.dumpdata.com>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
 <1392733738-8290-6-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392733738-8290-6-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 03:28:43PM +0100, Andi Kleen wrote:
> From: Joe Mario <jmario@redhat.com>
> 
> Here is the workaround I made for having the kernel not reject modules
> built with -flto.  The clean solution would be to get the compiler to not
> emit the symbol.  Or if it has to emit the symbol, then emit it as
> initialized data but put it into a comdat/linkonce section.
> 
> Minor tweaks by AK over Joe's patch.

Should Joe's SOB be on this patch ?
> 
> Cc: rusty@rustcorp.com.au
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/module.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index d24fcf2..b99e801 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1948,6 +1948,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  
>  		switch (sym[i].st_shndx) {
>  		case SHN_COMMON:
> +			/* Ignore common symbols */
> +			if (!strncmp(name, "__gnu_lto", 9))
> +				break;
> +
>  			/* We compiled with -fno-common.  These are not
>  			   supposed to happen.  */
>  			pr_debug("Common symbol: %s\n", name);
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
