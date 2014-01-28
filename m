Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaA1Uy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:54:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaA1Uy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:54:26 -0500
Date: Tue, 28 Jan 2014 21:54:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 4/5] mutex: Disable preemtion between modifying
 lock->owner and locking/unlocking mutex
Message-ID: <20140128205406.GI11314@laptop.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-5-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390936396-3962-5-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:13:15AM -0800, Jason Low wrote:
> This RFC patch disables preemption between modifying lock->owner and
> locking/unlocking the mutex lock. This prevents situations where the owner
> can preempt between those 2 operations, which causes optimistic spinners to
> be unable to check if lock->owner is not on CPU. As mentioned in the
> thread for this v1 patchset, disabling preemption is a cheap operation.

In that same thread it was also said that this wasn't really an issue at
all. So what is the justification?

The patch is rather hideous.
