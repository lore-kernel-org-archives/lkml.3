Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbaDJS5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:57:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161064AbaDJSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:55:39 -0400
Date: Thu, 10 Apr 2014 18:32:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
 for_each_thread()
Message-ID: <20140410163212.GH13658@twins.programming.kicks-ass.net>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
 <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
 <20140409171607.GA13498@dyad.arnhem.chello.nl>
 <20140409173233.GA28615@redhat.com>
 <20140409183017.GF10526@twins.programming.kicks-ass.net>
 <20140409194603.GB5854@redhat.com>
 <20140409194957.GD26782@laptop.programming.kicks-ass.net>
 <20140410161955.GG13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410161955.GG13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 06:19:55PM +0200, Peter Zijlstra wrote:
> On Wed, Apr 09, 2014 at 09:49:57PM +0200, Peter Zijlstra wrote:
> > Anyway, I'll look over the stuff tomorrow.
> 
> That patch was missing useful clues..
> 
> Also, I shot __for_each_thread in the head, it seemed useless.

Hmm, do we really want to have for_each_process_thread() ? Having people
explicitly write:

  for_each_process(p) {
  	for_each_thread(p, t) {
	}
  }

isn't that much more effort and its a whole lot more explicit on the
double loop thing.
