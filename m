Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3HNQwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:52:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60235 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab3HNQwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:52:39 -0400
Date: Wed, 14 Aug 2013 18:52:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Galbraith <bitbucket@online.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
Message-ID: <20130814165227.GA21191@laptop.programming.kicks-ass.net>
References: <20130814131539.790947874@chello.nl>
 <520B8A81.1080405@zytor.com>
 <1376494751.7355.28.camel@marge.simpson.net>
 <20130814160632.GJ24092@twins.programming.kicks-ass.net>
 <520BACEA.50604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BACEA.50604@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:14:34AM -0700, H. Peter Anvin wrote:
> Even so, this_rq() uses __get_cpu_var() and takes its address, which
> turns into a sequence like:
> 
> 	leaq __percpu_runqueues(%rip),%rax
> 	addq %gs:this_cpu_off,%rax
> 
> ... which is better than the above but still more heavyweight than it
> would be if the pointer was itself a percpu variable.

Oh curses, this is because lea can't do segment offsets? So there's no
sane way to get addresses of per-cpu variables.

Because ideally we'd have something like:

  lea %gs:__percpu_runqueues,%rax

So in this case it makes sense to also store the actual pointer; how
unfortunate.
