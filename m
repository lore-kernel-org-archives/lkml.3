Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaBJRiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:38:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54830 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaBJRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:38:49 -0500
Date: Mon, 10 Feb 2014 18:38:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: allow preemption in check_task_state
Message-ID: <20140210173833.GQ9987@twins.programming.kicks-ass.net>
References: <20140210153856.GD20017@opentech.at>
 <20140210111106.67438d1e@gandalf.local.home>
 <20140210171712.GA17517@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210171712.GA17517@opentech.at>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:17:12PM +0100, Nicholas Mc Guire wrote:
> maybe I'm missing/missunderstanding something here but
> pi_unlock -> arch_spin_unlock is a full mb() 

Nope, arch_spin_unlock() on x86 is a single add[wb] without LOCK prefix.

The lock and unlock primitives are in general specified to have ACQUIRE
resp. RELEASE semantics.

See Documentation/memory-barriers.txt for far too much head-hurting
details.
