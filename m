Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaAGPJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:09:37 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23093 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751364AbaAGPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:09:30 -0500
Date: Tue, 7 Jan 2014 15:09:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Zhang <markz@nvidia.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gary King <gking@nvidia.com>
Subject: Re: [PATCH] arm: mm: add memory type for inner-writeback
Message-ID: <20140107150918.GA16947@localhost>
References: <1388120328-17148-1-git-send-email-markz@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388120328-17148-1-git-send-email-markz@nvidia.com>
Thread-Topic: [PATCH] arm: mm: add memory type for inner-writeback
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 04:58:48AM +0000, Mark Zhang wrote:
> From: Colin Cross <ccross@android.com>
> 
> For streaming-style operations (e.g., software rendering of graphics
> surfaces shared with non-coherent DMA devices), the cost of performing
> L2 cache maintenance can exceed the benefit of having the larger cache
> (this is particularly true for OUTER_CACHE configurations like the ARM
> PL2x0).
> 
> This change uses the currently-unused mapping 5 (TEX[0]=1, C=0, B=1)
> in the tex remapping tables as an inner-writeback-write-allocate, outer
> non-cacheable memory type, so that this mapping will be available to
> clients which will benefit from the reduced L2 maintenance.
> 
> Signed-off-by: Gary King <gking@nvidia.com>

Is Colin signing off this patch as well?

> --- a/arch/arm/mm/proc-v7-2level.S
> +++ b/arch/arm/mm/proc-v7-2level.S
> @@ -144,8 +144,8 @@ ENDPROC(cpu_v7_set_pte_ext)
>  	 *   NS1 = PRRR[19] = 1		- normal shareable property
>  	 *   NOS = PRRR[24+n] = 1	- not outer shareable
>  	 */
> -.equ	PRRR,	0xff0a81a8
> -.equ	NMRR,	0x40e040e0
> +.equ	PRRR,	0xff0a89a8
> +.equ	NMRR,	0x40e044e0

It should be done for the *-3level files.

-- 
Catalin
