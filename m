Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab3GZPKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:10:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38767 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab3GZPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:10:36 -0400
Date: Fri, 26 Jul 2013 16:10:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 0/5] mm: ARM nobootmem and few dma_mask fixes
Message-ID: <20130726151021.GU24642@n2100.arm.linux.org.uk>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 05:48:09PM -0400, Santosh Shilimkar wrote:
> The series is an attempt to move ARM port to NO_BOOTMEM. As discussed
> on list NO_BOOTMEM move needed updates to max*pfn meaning to be maximum
> PFNs but that breaks the dma_mask for few block layer drivers since
> ARM start of physical memory is not PFN0 unlike most of the architectures.
> Some more read on it is here:
> 	http://lwn.net/Articles/543408/
> 	http://lwn.net/Articles/543424/
> 
> To address this issue, we introduce generic dma_max_pfn() helper which
> can be overridden from the architectures.
> 	
> Another intention behind move to nobootmem is also to convert ARM to
> switch to memblock and getting rid of bootmem allocator dependency which
> don't work for LPAE machines which has physical memory starting beyond
> 4 GB boundary. It needs changes to core kernel and also a new memblock
> API. More on this can be found here:
> 	https://lkml.org/lkml/2013/6/29/77
> 
> I have been trying to cook up these patches with kind help from Russell
> and we know series don't solve all the dma_mask bad assumptions. But at
> least I am hoping that it can get the ball rolling.	
> 
> Comments/testing help is welcome !!

As this is related to some of the cleanup of dma_mask which I've been
doing, I think it may make sense to roll this into one tree.  Any
objection to that?

Can we get any acks on this stuff from Jens and Jejb etc - especially
for the bits which touch block/ and for the scsi bits as these are
touching other subsystems.  (oddly, linux-scsi wasn't on the original
mail for this series summary.)
