Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaEUA1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 20:27:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38929 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaEUA1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 20:27:03 -0400
Date: Tue, 20 May 2014 19:26:58 -0500
From: rkuo <rkuo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hexagon: remove check for CONFIG_COMET_EARLY_UART_DEBUG
Message-ID: <20140521002658.GG12698@codeaurora.org>
References: <1400327586.13824.10.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400327586.13824.10.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 01:53:06PM +0200, Paul Bolle wrote:
> There's been a check for CONFIG_COMET_EARLY_UART_DEBUG ever since
> Hexagon was added in v3.2. But the related Kconfig symbol has never been
> added to the tree. Remove this check.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Not tested.
> 
>  arch/hexagon/kernel/vm_init_segtable.S | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/hexagon/kernel/vm_init_segtable.S b/arch/hexagon/kernel/vm_init_segtable.S
> index 80967f2192b3..167b48458620 100644
> --- a/arch/hexagon/kernel/vm_init_segtable.S
> +++ b/arch/hexagon/kernel/vm_init_segtable.S
> @@ -85,12 +85,7 @@ swapper_pg_dir:
>  	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
>  	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
>  /*0xa8*/.word X,X,X,X
> -#ifdef CONFIG_COMET_EARLY_UART_DEBUG
> -UART_PTE_ENTRY:
> -/*0xa9*/.word BKPG_IO(0xa9000000),BKPG_IO(0xa9000000),BKPG_IO(0xa9000000),BKPG_IO(0xa9000000)
> -#else
>  /*0xa9*/.word X,X,X,X
> -#endif
>  /*0xaa*/.word X,X,X,X
>  /*0xab*/.word X,X,X,X
>  /*0xac*/.word X,X,X,X
> -- 
> 1.9.0
> 

Thanks, I'll include this in my next set, or it can go via anyone else's.

Acked-by: Ricahrd Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
