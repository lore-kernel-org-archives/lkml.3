Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaEBPv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:51:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbaEBPv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:51:26 -0400
Message-ID: <1399045859.1604.1.camel@deneb.redhat.com>
Subject: Re: [PATCH 0/2] arm64: TLB flush issues
From: Mark Salter <msalter@redhat.com>
To: Steve Capper <steve.capper@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 02 May 2014 11:50:59 -0400
In-Reply-To: <20140502153019.GA9179@linaro.org>
References: <1399044035-11274-1-git-send-email-msalter@redhat.com>
	 <20140502153019.GA9179@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 16:30 +0100, Steve Capper wrote:
> On Fri, May 02, 2014 at 11:20:33AM -0400, Mark Salter wrote:
> > As explained in more detail in the second patch, I have observed a soft
> > lockup under some loads. These lockups were in flush_tlb_kernel_range()
> > which was looping through a very large address range. While looking into
> > this, I also noticed the flush routines in tlb.S were not properly
> > handling pages larger than 4k. This is corrected in the first patch.
> > The second patch limits the loop size for the flush_tlb_[kernel_]range
> > functions. It uses an arbitrary constant to limit the loop, but it
> > would be better if it were based on actual tlb size or some other
> > heuristic.
> > 
> > Mark Salter (2):
> >   arm64: fix unnecessary tlb flushes
> >   arm64: fix soft lockup due to large tlb flush range
> > 
> >  arch/arm64/include/asm/tlbflush.h | 28 +++++++++++++++++++++++++---
> >  arch/arm64/mm/tlb.S               |  4 ++--
> >  2 files changed, 27 insertions(+), 5 deletions(-)
> > 
> 
> Hi Mark,
> As a heads-up, I posted this earlier today:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/252837.html
> 
> Cheers,

Thanks. That takes care of the pagesize handling (my patch 1/2).


