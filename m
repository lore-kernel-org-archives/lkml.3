Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735Ab3DBQvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:51:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54735 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761656Ab3DBQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:51:33 -0400
Date: Tue, 2 Apr 2013 17:51:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Fix typo "CONFIG_LPAE" twice
Message-ID: <20130402165114.GI6608@mudshark.cambridge.arm.com>
References: <1364563104.1345.74.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364563104.1345.74.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, Mar 29, 2013 at 01:18:24PM +0000, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) This typo was first introduced in v3.4: commit
> e5ab85800820edd907d3f43f285e1232f84d5a41 ("ARM: 7382/1: mm: truncate
> memory banks to fit in 4GB space for classic MMU"). The second instance
> was added in v3.9-rc2: commit d61947a164760ac520cb416768afdf38c33d60e7
> (" ARM: 7657/1: head: fix swapper and idmap population with LPAE and
> big-endian"). So testing is really needed here.
> 
> 2) If this passes (review and) testing, this probably needs to go to
> stable too.
> 
>  arch/arm/kernel/head.S  | 2 +-
>  arch/arm/kernel/setup.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index e0eb9a1..8bac553 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -267,7 +267,7 @@ __create_page_tables:
>  	addne	r6, r6, #1 << SECTION_SHIFT
>  	strne	r6, [r3]
>  
> -#if defined(CONFIG_LPAE) && defined(CONFIG_CPU_ENDIAN_BE8)
> +#if defined(CONFIG_ARM_LPAE) && defined(CONFIG_CPU_ENDIAN_BE8)
>  	sub	r4, r4, #4			@ Fixup page table pointer
>  						@ for 64-bit descriptors
>  #endif

The problem with this code is that there are very few people with platforms
on which they can test it. You need an LPAE-capable CPU (Cortex-A7 or
Cortex-A15) sitting on a big-endian platform. The only platform that I have
for that is KVM, which doesn't have earlyprintk support.

Now, without the offending patch, such a configuration didn't even boot, but
I can't verify that the mapping actually works. Of course, what you have
written was the intended behaviour, so perhaps we should just go with that
for the time being.

Will
