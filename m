Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3I3TXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:23:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:35203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab3I3TXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:23:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1009,1371106800"; 
   d="scan'208";a="385865930"
Subject: Re: [PATCH, v2] anon_vmas: Convert the rwsem to an rwlock_t
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
In-Reply-To: <20130930181411.GO15690@laptop.programming.kicks-ass.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	 <20130928074144.GA17773@gmail.com>
	 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	 <20130928192123.GA8228@gmail.com> <20130928193739.GA8642@gmail.com>
	 <CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>
	 <20130928195207.GA31245@gmail.com> <1380561027.3467.196.camel@schen9-DESK>
	 <20130930181411.GO15690@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Sep 2013 12:23:07 -0700
Message-ID: <1380568987.3467.198.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 20:14 +0200, Peter Zijlstra wrote:
> On Mon, Sep 30, 2013 at 10:10:27AM -0700, Tim Chen wrote:
> > Here's the exim workload data:
> > 
> > rwsem improvment:
> > Waimain's patch:        +2.0%
> > Alex+Tim's patchset:    +4.8%
> > Waiman+Alex+Tim:        +5.3%
> > 
> > convert rwsem to rwlock_t for root anon_vma lock
> > Ingo's patch		+11.7%
> > 
> 
> What happens if you stuff Waiman's qrwlock patches on top of that?
> admittedly and oft mentioned in this thread, our current rwlock_t is
> somewhat suboptimal under a number of conditions.

I've tested with Waiman's qrwlock patches on top of Ingo's patches.
It does not affect the throughput for exim and I still get
about +11.7% throughput change (same as with Ingo's patch only).

Tim

