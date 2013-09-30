Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3I3QmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:42:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46598 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3I3QmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:42:07 -0400
Date: Mon, 30 Sep 2013 18:41:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
Message-ID: <20130930164141.GH3081@twins.programming.kicks-ass.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
 <20130930104408.GW3081@twins.programming.kicks-ass.net>
 <CA+55aFwTCCXaD4S4OPGmwf=fhOwWdxr8NU9uFvdf_nRx0Nk0_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwTCCXaD4S4OPGmwf=fhOwWdxr8NU9uFvdf_nRx0Nk0_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 09:13:52AM -0700, Linus Torvalds wrote:
 
> So unlike a lot of other "let's try to make our locking fancy" that I
> dislike because it tends to hide the fundamental problem of
> contention, the rwlock patches make me go "those actually _fix_ a
> fundamental problem".

So here I'm slightly disagreeing; fixing a fundamental problem would be
coming up a better anon_vma management that doesn't create such immense
chains.

Its still the same lock, spinlock or not. 

And regardless of if we keep anon_vma lock a rwsem or not; I think we
should merge those rwsem patches as they do improve the lock
implementation and the hard work has already been done.

However the biggest ugly by far here is that mm_take_all_locks() thing;
couldn't we implement that by basically freezing all tasks referencing
that mm?
