Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaJAWpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:45:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaJAWo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:44:59 -0400
Date: Wed, 1 Oct 2014 15:44:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>,
        linux-kernel@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH] fork.c: copy_process(): fix cleanup WRT
 perf_event_free_task()
Message-Id: <20141001154458.a3c4bfa7ef000ecc1fc7c5de@linux-foundation.org>
In-Reply-To: <20140929140048.GK5430@worktop>
References: <20140926210652.GA27199@erable>
	<20140927180725.GA15594@redhat.com>
	<20140929101201.GE5430@worktop>
	<20140929120722.GA11943@gmail.com>
	<20140929140048.GK5430@worktop>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 16:00:48 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Sep 29, 2014 at 02:07:22PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Subject: perf: Fix perf bug in fork()
> > > 
> > > Oleg noticed that a cleanup by Sylvain actually uncovered a bug; by
> > > calling perf_event_free_task() when failing sched_fork() we will not yet
> > > have done the memset() on ->perf_event_ctxp[] and will therefore try and
> > > 'free' the inherited contexts, which are still in use by the parent
> > > process. This is bad..
> > > 
> > > Suggested-by: Oleg Nesterov <oleg@redhat.com>
> > > Reported-by: Oleg Nesterov <oleg@redhat.com>
> > > Reported-by: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > 
> > Could this fix a couple of fuzzer triggered perf crashes perhaps?
> 
> It could indeed I suppose.. you never know what paths those fuzzers
> manage to hit.

The patch isn't in linux-next and didn't cc stable.  I think I'll
squirt it Linuswards later this week unless someone stops me..

