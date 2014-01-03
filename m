Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaACTzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 14:55:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbaACTzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:55:19 -0500
Date: Fri, 3 Jan 2014 20:55:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2 0/1] mm: fix the theoretical compound_lock() vs
	prep_new_page() race
Message-ID: <20140103195519.GA26555@redhat.com>
References: <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216183618.GA28252@redhat.com> <20131216201952.GE21218@redhat.com> <20131219190846.GA24566@redhat.com> <20131219190920.GB24566@redhat.com> <20131223114300.GC727@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131223114300.GC727@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Andrea Arcangeli wrote:
>
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>
>
> Only one improvement possible, the smp_wmb() could have been put under
> CONFIG_TRANSPARENT_HUGEPAGE somehow. No difference for x86-64 though.

I thought it would be better to serialize it with get_page_unless_zero()
in general, but OK, As the changelog says I didn't find another problematic
caller, so please see v2. I preserved your ack, thanks.

And I would like to know your opinion about other changes I sent ;)

Oleg.

