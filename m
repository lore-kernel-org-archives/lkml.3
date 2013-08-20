Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab3HTIoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:44:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52517 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3HTIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:44:18 -0400
Date: Tue, 20 Aug 2013 10:44:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130820084405.GC3258@twins.programming.kicks-ass.net>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
 <20130819111026.GE24092@twins.programming.kicks-ass.net>
 <521313D8.9080500@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <521313D8.9080500@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 03:59:36PM +0900, Fernando Luis Vázquez Cao wrote:
> That said, if deemed acceptable, option A is the one I would
> choose.

Right, so I think we can do A without much extra cost mostly because we
already have 2 atomics in the io_schedule() path. If we replace those
two atomic operations with locks and modify nr_iowait and the other
stats under the same lock, and ensure all those variables (including the
lock) live in the same cacheline we should have the same cost we have
now.

Of course, if we can get away with completely removing all of that
(which I think Arjan suggested was a real possibility) then that would
be ever so much better still :-)
