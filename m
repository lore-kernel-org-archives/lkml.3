Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbaGXOqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:46:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007AbaGXOqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:46:06 -0400
Date: Thu, 24 Jul 2014 16:44:49 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, jroedel@suse.de,
        Jay.Cornwall@amd.com, Oded.Gabbay@amd.com, John.Bridgman@amd.com,
        Suravee.Suthikulpanit@amd.com, ben.sander@amd.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] mmu_notifier: Allow to manage CPU external TLBs
Message-ID: <20140724144449.GC27715@redhat.com>
References: <1406212541-25975-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406212541-25975-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:35:38PM +0200, Joerg Roedel wrote:
> To solve this situation I wrote a patch-set to introduce a
> new notifier call-back: mmu_notifer_invalidate_range(). This
> notifier lifts the strict requirements that no new
> references are taken in the range between _start() and
> _end(). When the subsystem can't guarantee that any new
> references are taken is has to provide the
> invalidate_range() call-back to clear any new references in
> there.
> 
> It is called between invalidate_range_start() and _end()
> every time the VMM has to wipe out any references to a
> couple of pages. This are usually the places where the CPU
> TLBs are flushed too and where its important that this
> happens before invalidate_range_end() is called.
> 
> Any comments and review appreciated!

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
