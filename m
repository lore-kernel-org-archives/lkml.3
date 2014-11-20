Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaKTMej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:34:39 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:52109 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbaKTMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:34:37 -0500
Date: Thu, 20 Nov 2014 12:34:34 +0000
From: Paul Burton <paul.burton@imgtec.com>
To: Niklas Svensson <niklas.svensson@axis.com>
CC: <ralf@linux-mips.org>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>, Niklas Svensson <niklass@axis.com>
Subject: Re: [PATCH] MIPS: mips-cm: CM regions are disabled at boot
Message-ID: <20141120123434.GW1127@pburton-laptop>
References: <1416486540-28681-1-git-send-email-niklass@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1416486540-28681-1-git-send-email-niklass@axis.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.159.42]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 01:29:00PM +0100, Niklas Svensson wrote:
> Each CM_REGION_TARGET is set to disabled at boot,

That part is true...

> so there is no need to disable the matching
> CM_GCR_REG explicitly.

...however there is no guarantee that the bootloader, or another kernel,
or some other piece of code didn't program the registers differently
before Linux starts. So I believe this patch to be incorrect.

Thanks,
    Paul

> 
> Signed-off-by: Niklas Svensson <niklass@axis.com>
> ---
>  arch/mips/kernel/mips-cm.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/arch/mips/kernel/mips-cm.c b/arch/mips/kernel/mips-cm.c
> index f76f7a0..a4bbfd9 100644
> --- a/arch/mips/kernel/mips-cm.c
> +++ b/arch/mips/kernel/mips-cm.c
> @@ -104,16 +104,6 @@ int mips_cm_probe(void)
>  	base_reg |= CM_GCR_BASE_CMDEFTGT_MEM;
>  	write_gcr_base(base_reg);
>  
> -	/* disable CM regions */
> -	write_gcr_reg0_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
> -	write_gcr_reg0_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
> -	write_gcr_reg1_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
> -	write_gcr_reg1_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
> -	write_gcr_reg2_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
> -	write_gcr_reg2_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
> -	write_gcr_reg3_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
> -	write_gcr_reg3_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
> -
>  	/* probe for an L2-only sync region */
>  	mips_cm_probe_l2sync();
>  
> -- 
> 2.1.3
> 
