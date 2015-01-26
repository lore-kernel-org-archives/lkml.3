Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbbAZRMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:12:12 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58091 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbAZRMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:12:09 -0500
Date: Mon, 26 Jan 2015 18:12:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched, timer: Use atomics for thread_group_cputimer
 stats
Message-ID: <20150126171200.GB23038@twins.programming.kicks-ass.net>
References: <1421983913.4432.22.camel@j-VirtualBox>
 <20150123092508.GJ2896@worktop.programming.kicks-ass.net>
 <1422041016.2436.19.camel@j-VirtualBox>
 <20150123200828.GE23123@twins.programming.kicks-ass.net>
 <1422056755.2436.36.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422056755.2436.36.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 03:45:55PM -0800, Jason Low wrote:
> On a side note, if we just move the cputimer->running = 1 to after the
> call to update_gt_cputime in thread_group_cputimer(), then we don't have
> to worry about concurrent adds occuring in this function?

Yeah, maybe.. There are a few races there, but I figure that because we
already test cputimer->running outside of cputimer->lock they're already
possible.

