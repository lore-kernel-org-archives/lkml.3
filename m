Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3LJV0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:26:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44241 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3LJV0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:26:10 -0500
Date: Tue, 10 Dec 2013 21:25:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm/ARM: dma: fix conflicting types for
	'arm_dma_zone_size'
Message-ID: <20131210212523.GE4360@n2100.arm.linux.org.uk>
References: <1386703798-26521-1-git-send-email-santosh.shilimkar@ti.com> <1386703798-26521-2-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386703798-26521-2-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 02:29:57PM -0500, Santosh Shilimkar wrote:
> diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
> index 58b8c6a..1439b80 100644
> --- a/arch/arm/include/asm/dma.h
> +++ b/arch/arm/include/asm/dma.h
> @@ -8,7 +8,7 @@
>  #define MAX_DMA_ADDRESS	0xffffffffUL
>  #else
>  #define MAX_DMA_ADDRESS	({ \
> -	extern unsigned long arm_dma_zone_size; \
> +	extern phys_addr_t arm_dma_zone_size; \
>  	arm_dma_zone_size ? \
>  		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })

This is wrong.  Take a moment to look at it more closely.  What does
"PAGE_OFFSET" tell you about what its returning?

What happens if arm_dma_zone_size is greater than 1GB when PAGE_OFFSET
is at the default setting of 3GB?
