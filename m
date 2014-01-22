Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaAVNLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:11:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbaAVNLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:11:01 -0500
Date: Wed, 22 Jan 2014 14:10:46 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mike Rapoport <mike.rapoport@ravellosystems.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Haggai Eran <haggaie@mellanox.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] mm/mmu_notifier: restore set_pte_at_notify semantics
Message-ID: <20140122131046.GF14193@redhat.com>
References: <1389778834-21200-1-git-send-email-mike.rapoport@ravellosystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389778834-21200-1-git-send-email-mike.rapoport@ravellosystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 11:40:34AM +0200, Mike Rapoport wrote:
> Commit 6bdb913f0a70a4dfb7f066fb15e2d6f960701d00 (mm: wrap calls to
> set_pte_at_notify with invalidate_range_start and invalidate_range_end)
> breaks semantics of set_pte_at_notify. When calls to set_pte_at_notify
> are wrapped with mmu_notifier_invalidate_range_start and
> mmu_notifier_invalidate_range_end, KVM zaps pte during
> mmu_notifier_invalidate_range_start callback and set_pte_at_notify has
> no spte to update and therefore it's called for nothing.
> 
> As Andrea suggested (1), the problem is resolved by calling
> mmu_notifier_invalidate_page after PT lock has been released and only
> for mmu_notifiers that do not implement change_ptr callback.
> 
> (1) http://thread.gmane.org/gmane.linux.kernel.mm/111710/focus=111711
> 
> Reported-by: Izik Eidus <izik.eidus@ravellosystems.com>
> Signed-off-by: Mike Rapoport <mike.rapoport@ravellosystems.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Haggai Eran <haggaie@mellanox.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/mmu_notifier.h | 31 ++++++++++++++++++++++++++-----
>  kernel/events/uprobes.c      | 12 ++++++------
>  mm/ksm.c                     | 15 +++++----------
>  mm/memory.c                  | 14 +++++---------
>  mm/mmu_notifier.c            | 24 ++++++++++++++++++++++--
>  5 files changed, 64 insertions(+), 32 deletions(-)

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

Thanks!
Andrea
