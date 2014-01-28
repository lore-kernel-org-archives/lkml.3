Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaA1WRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:17:52 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:37659 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaA1WRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:17:51 -0500
Message-ID: <1390947469.2807.33.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v2 4/5] mutex: Disable preemtion between modifying
 lock->owner and locking/unlocking mutex
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 28 Jan 2014 14:17:49 -0800
In-Reply-To: <20140128205406.GI11314@laptop.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-5-git-send-email-jason.low2@hp.com>
	 <20140128205406.GI11314@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 21:54 +0100, Peter Zijlstra wrote:
> On Tue, Jan 28, 2014 at 11:13:15AM -0800, Jason Low wrote:
> > This RFC patch disables preemption between modifying lock->owner and
> > locking/unlocking the mutex lock. This prevents situations where the owner
> > can preempt between those 2 operations, which causes optimistic spinners to
> > be unable to check if lock->owner is not on CPU. As mentioned in the
> > thread for this v1 patchset, disabling preemption is a cheap operation.
> 
> In that same thread it was also said that this wasn't really an issue at
> all. So what is the justification?

This patch is mainly just a complementary patch for patch 5 so that we
can allow the spinner to wait slightly longer for lock->count to get set
without worrying about need_resched()/owner getting preempted.

Jason


