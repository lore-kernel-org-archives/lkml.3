Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaAXPib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:38:31 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42754 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752948AbaAXPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:38:30 -0500
Date: Fri, 24 Jan 2014 15:37:56 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        Somraj Mani <somraj.mani@samsung.com>
Subject: Re: [PATCH] arm64: fix build error if DMA_CMA is enabled
Message-ID: <20140124153756.GH19052@arm.com>
References: <1390551788-6138-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390551788-6138-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 08:23:08AM +0000, Pankaj Dubey wrote:
> arm64/include/asm/dma-contiguous.h is trying to include
> <asm-genric/dma-contiguous.h> which does not exist, and thus failing
> build for arm64 if we enable CONFIG_DMA_CMA. This patch fixes build 
> error by removing unwanted header inclusion from arm64's dma-contiguous.h.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Somraj Mani <somraj.mani@samsung.com>
> ---
>  arch/arm64/include/asm/dma-contiguous.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/dma-contiguous.h b/arch/arm64/include/asm/dma-contiguous.h
> index d6aacb6..14c4c0c 100644
> --- a/arch/arm64/include/asm/dma-contiguous.h
> +++ b/arch/arm64/include/asm/dma-contiguous.h
> @@ -18,7 +18,6 @@
>  #ifdef CONFIG_DMA_CMA
>  
>  #include <linux/types.h>
> -#include <asm-generic/dma-contiguous.h>

Thanks for this.

Laura, did you have additional patches adding
asm-generic/dma-contiguous.h?

-- 
Catalin
