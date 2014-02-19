Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaBSI7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:59:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaBSI7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:59:20 -0500
Date: Wed, 19 Feb 2014 09:59:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        chegu_vinod@hp.com, aarcange@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH -mm 0/3] fix numa vs kvm scalability issue
Message-ID: <20140219085917.GJ27965@twins.programming.kicks-ass.net>
References: <1392761566-24834-1-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392761566-24834-1-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 05:12:43PM -0500, riel@redhat.com wrote:
> The NUMA scanning code can end up iterating over many gigabytes
> of unpopulated memory, especially in the case of a freshly started
> KVM guest with lots of memory.
> 
> This results in the mmu notifier code being called even when
> there are no mapped pages in a virtual address range. The amount
> of time wasted can be enough to trigger soft lockup warnings
> with very large (>2TB) KVM guests.
> 
> This patch moves the mmu notifier call to the pmd level, which
> represents 1GB areas of memory on x86-64. Furthermore, the mmu
> notifier code is only called from the address in the PMD where
> present mappings are first encountered.
> 
> The hugetlbfs code is left alone for now; hugetlb mappings are
> not relocatable, and as such are left alone by the NUMA code,
> and should never trigger this problem to begin with.
> 
> The series also adds a cond_resched to task_numa_work, to
> fix another potential latency issue.

Andrew, I'll pick up the first kernel/sched/ patch; do you want the
other two mm/ patches?
