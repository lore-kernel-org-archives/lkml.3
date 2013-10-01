Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3JAIK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:10:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59442 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3JAIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:10:55 -0400
Date: Tue, 1 Oct 2013 10:10:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20131001081011.GM3081@twins.programming.kicks-ass.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130930104658.GX3081@twins.programming.kicks-ass.net>
 <20131001074802.GB20889@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001074802.GB20889@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 09:48:02AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, Sep 28, 2013 at 11:55:26AM -0700, Linus Torvalds wrote:
> > > So if the primary reason for this is really just that f*cking anon_vma
> > > lock, then I would seriously suggest:
> > 
> > I would still like to see the rwsem patches merged; even if we end up 
> > going back to a spin style anon_vma lock.
> > 
> > There's been various reports in the past about how programs are 
> > significantly faster if they wrap their mmap() calls in a pthread_mutex. 
> > And this was purely down to the fact that rwsem writer-writer contention 
> > blows chunks.
> 
> That's about the mm->mmap_sem rwsem, right?

Yep.

> That impact would have to be measured carefully, and not just for 
> workloads where we know that better contention logic helps, but other MM 
> workloads that are hitting hard on mmap_sem.

Sure.
