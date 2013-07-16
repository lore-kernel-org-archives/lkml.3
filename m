Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab3GPUR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:17:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47494 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497Ab3GPUR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:17:26 -0400
Date: Tue, 16 Jul 2013 22:17:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130716201702.GW17211@twins.programming.kicks-ass.net>
References: <51E166C8.3000902@linux.intel.com>
 <20130715195914.GC23818@dyad.programming.kicks-ass.net>
 <51E45E8B.705@linux.intel.com>
 <20130715210650.GF23818@dyad.programming.kicks-ass.net>
 <20130715211230.GG23818@dyad.programming.kicks-ass.net>
 <51E47D30.5030203@linux.intel.com>
 <20130716173848.GA22795@dyad.programming.kicks-ass.net>
 <51E5947F.4090109@linux.intel.com>
 <20130716192145.GV17211@twins.programming.kicks-ass.net>
 <51E5A5AE.7010903@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E5A5AE.7010903@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:57:34PM -0700, Arjan van de Ven wrote:
> then the question of how much remaining capacity; this is a hard one, and not just
> for Intel. Almost all mobile devices today are thermally constrained, ARM and Intel
> alike (at least the higher performance ones)... the curse of wanting very thin and light
> phones that are made of thermally isolating plastic (so that radio waves can go through)
> and have a nice and bright screen...

Right, so we might need to track a !idle avg over the thermal domain to
guestimate the head-room and inter-cpu relations.

But yeah, I suppose what I've been saying is that we need to drag
cpufreq into the SMP era. Only considering a single cpu isn't going to
work anymore.
