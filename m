Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaILT2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:28:48 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:63146 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaILT2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:28:46 -0400
Date: Fri, 12 Sep 2014 15:28:37 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <jroedel@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, Jay.Cornwall@amd.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, John.Bridgman@amd.com,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        ben.sander@amd.com, linux-mm@kvack.org,
        Jerome Glisse <jglisse@redhat.com>, iommu@lists.linux-foundation.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Mel Gorman <mgorman@suse.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 0/3 v3] mmu_notifier: Allow to manage CPU external TLBs
Message-ID: <20140912192837.GC5196@gmail.com>
References: <1410277434-3087-1-git-send-email-joro@8bytes.org>
 <20140910150125.31a7495c7d0fe814b85fd514@linux-foundation.org>
 <20140912184739.GF2519@suse.de>
 <20140912121937.ebb3010d52abd4196e9341de@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140912121937.ebb3010d52abd4196e9341de@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 12:19:37PM -0700, Andrew Morton wrote:
> On Fri, 12 Sep 2014 20:47:39 +0200 Joerg Roedel <jroedel@suse.de> wrote:
> 
> > thanks for your review, I tried to answer your questions below.
> 
> You'd be amazed how helpful that was ;)
> 
> > Fair enough, I hope I clarified a few things with my explanations
> > above. I will also update the description of the patch-set when I
> > re-send.
> 
> Sounds good, thanks.
> 
> 
> How does HMM play into all of this?  Would HMM make this patchset
> obsolete, or could HMM be evolved to do so?  

HMM should be consider as distinc from this. The hardware TLB we are talking
with this patchset can be flush by the CPU from inside an atomic context (ie
while holding cpu page table spinlock for instance).

HMM on the other hand deals with hardware that have there own page table
ie they do not necessarily walk the cpu page table. Flushing the TLB for this
kind of hardware means scheduling some job on the hardware and this can not
be done from kernel atomic context as this job might take a long time to
complete (imagine preempting thousand of threads on a gpu).

Still HMM can be use in a mixed environement where the IOMMUv2 is use for
memory that reside into system ram while HMM only handle memory that have
been migrated to the device memory.

So while HMM intend to provide more features than IOMMUv2 hardware allow,
it does not intend to replace it. On contrary hope is that both can work at
same time.

Cheers,
Jérôme

> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
