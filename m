Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3I3QLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:11:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45913 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3I3QLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:11:53 -0400
Date: Mon, 30 Sep 2013 18:11:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
Message-ID: <20130930161141.GF3081@twins.programming.kicks-ass.net>
References: <20130930152242.207382649@infradead.org>
 <CA+55aFzs-+2HCAjxU=7FJ-1+q1hnDADJ_rzTRdMuDrzzYAVstw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzs-+2HCAjxU=7FJ-1+q1hnDADJ_rzTRdMuDrzzYAVstw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 08:50:04AM -0700, Linus Torvalds wrote:
> On Mon, Sep 30, 2013 at 8:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Compile and boot tested on x86_64.
> 
> Btw, I assume the odd binary size reduction is gone now, and code
> generation is generally identical?

Over patch 4; yes. Patches 1-3 generate different kernels, esp patch 2
has a large drop in size, 5 too is invariant. Patch 6 however increases
code size again, but then it actually changes the generated code so
that's somewhat expected.

But with patches 1-3 its all clear what changes and why; and having the
big scary conversion patch 4 invariant is good.
