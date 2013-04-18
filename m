Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3DRLOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:14:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46108
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696Ab3DRLOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:14:45 -0400
Message-ID: <1366283681.19383.5.camel@laptop>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load
 average
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 18 Apr 2013 13:14:41 +0200
In-Reply-To: <20130415093330.GC17715@gmail.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
	 <20130415093330.GC17715@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 11:33 +0200, Ingo Molnar wrote:
> * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
> > Recent activity has had a focus on moving functionally related blocks of stuff 
> > out of sched/core.c into stand-alone files.  The code relating to load average 
> > calculations has grown significantly enough recently to warrant placing it in a 
> > separate file.
> > 
> > Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
> > 
> > A couple small static functions in the core sched.h header were also localized 
> > to their singular user in sched/fair.c at the same time, with the goal to also 
> > reduce the amount of "broadcast" content in that sched.h file.
> 
> Nice!
> 
> Peter, is this (and the naming of the new file) fine with you too?

Yes and no.. that is I do like the change, but I don't like the
filename. We have _waaaay_ too many different things we call load_avg.

That said, I'm having a somewhat hard time coming up with a coherent
alternative :/



