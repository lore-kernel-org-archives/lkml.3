Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaFXOPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:15:17 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25461 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752322AbaFXOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:15:12 -0400
Date: Tue, 24 Jun 2014 15:14:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: make CONFIG_ZONE_DMA user settable
Message-ID: <20140624141455.GE4489@arm.com>
References: <1403499924-11214-1-git-send-email-msalter@redhat.com>
 <20140623110937.GB15907@arm.com>
 <1403529423.755.49.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403529423.755.49.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 02:17:03PM +0100, Mark Salter wrote:
> On Mon, 2014-06-23 at 12:09 +0100, Catalin Marinas wrote:
> > My proposal (in the absence of any kind of description) is to still
> > create a ZONE_DMA if we have DMA memory below 32-bit, otherwise just add
> > everything (>32-bit) to ZONE_DMA. Basically an extension from your CMA
> > patch, make dma_phys_limit static in that file and set it to
> > memblock_end_of_DRAM() if no 32-bit DMA. Re-use it in the
> > zone_sizes_init() function for ZONE_DMA (maybe with a pr_info for no
> > 32-bit only DMA zone).
> 
> There's a performance issue with all memory being in ZONE_DMA. It means
> all normal allocations will fail on ZONE_NORMAL and then have to fall
> back to ZONE_DMA. It would be better to put some percentage of memory
> in ZONE_DMA.

Is the performance penalty real or just theoretical? I haven't run any
benchmarks myself.

-- 
Catalin
