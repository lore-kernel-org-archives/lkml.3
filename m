Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbaDJSfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:35:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53763 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934885AbaDJSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:35:34 -0400
Date: Thu, 10 Apr 2014 19:42:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
 for_each_thread()
Message-ID: <20140410174203.GA1429@laptop.programming.kicks-ass.net>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
 <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
 <20140409171607.GA13498@dyad.arnhem.chello.nl>
 <20140409173233.GA28615@redhat.com>
 <20140409183017.GF10526@twins.programming.kicks-ass.net>
 <20140409194603.GB5854@redhat.com>
 <20140409194957.GD26782@laptop.programming.kicks-ass.net>
 <20140410161955.GG13658@twins.programming.kicks-ass.net>
 <20140410172938.GA32332@redhat.com>
 <20140410173610.GG26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410173610.GG26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 07:36:10PM +0200, Peter Zijlstra wrote:
> > > +static inline __deprecated
> > > +struct task_struct *next_thread(const struct task_struct *p)
> > >  {
> > 
> > Not sure... But probably fine too.

Also, since its used in while_each_thread() each usage of that will also
generate an appropriate warn.
