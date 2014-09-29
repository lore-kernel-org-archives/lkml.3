Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaI2OAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:00:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:38031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaI2OAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:00:52 -0400
Date: Mon, 29 Sep 2014 16:00:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH] fork.c: copy_process(): fix cleanup WRT
 perf_event_free_task()
Message-ID: <20140929140048.GK5430@worktop>
References: <20140926210652.GA27199@erable>
 <20140927180725.GA15594@redhat.com>
 <20140929101201.GE5430@worktop>
 <20140929120722.GA11943@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929120722.GA11943@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 02:07:22PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Subject: perf: Fix perf bug in fork()
> > 
> > Oleg noticed that a cleanup by Sylvain actually uncovered a bug; by
> > calling perf_event_free_task() when failing sched_fork() we will not yet
> > have done the memset() on ->perf_event_ctxp[] and will therefore try and
> > 'free' the inherited contexts, which are still in use by the parent
> > process. This is bad..
> > 
> > Suggested-by: Oleg Nesterov <oleg@redhat.com>
> > Reported-by: Oleg Nesterov <oleg@redhat.com>
> > Reported-by: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> Could this fix a couple of fuzzer triggered perf crashes perhaps?

It could indeed I suppose.. you never know what paths those fuzzers
manage to hit.
