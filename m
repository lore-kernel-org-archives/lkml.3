Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaEBPaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:30:30 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47385 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaEBPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:30:29 -0400
Date: Fri, 2 May 2014 16:30:21 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] arm64: TLB flush issues
Message-ID: <20140502153019.GA9179@linaro.org>
References: <1399044035-11274-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399044035-11274-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 11:20:33AM -0400, Mark Salter wrote:
> As explained in more detail in the second patch, I have observed a soft
> lockup under some loads. These lockups were in flush_tlb_kernel_range()
> which was looping through a very large address range. While looking into
> this, I also noticed the flush routines in tlb.S were not properly
> handling pages larger than 4k. This is corrected in the first patch.
> The second patch limits the loop size for the flush_tlb_[kernel_]range
> functions. It uses an arbitrary constant to limit the loop, but it
> would be better if it were based on actual tlb size or some other
> heuristic.
> 
> Mark Salter (2):
>   arm64: fix unnecessary tlb flushes
>   arm64: fix soft lockup due to large tlb flush range
> 
>  arch/arm64/include/asm/tlbflush.h | 28 +++++++++++++++++++++++++---
>  arch/arm64/mm/tlb.S               |  4 ++--
>  2 files changed, 27 insertions(+), 5 deletions(-)
> 

Hi Mark,
As a heads-up, I posted this earlier today:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/252837.html

Cheers,
-- 
Steve
