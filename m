Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3J2NXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:23:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48827 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3J2NXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:23:53 -0400
Date: Tue, 29 Oct 2013 14:23:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        yoshihiro.yunomae.ez@hitachi.com
Subject: Re: RFC: paravirtualizing perf_clock
Message-ID: <20131029132343.GB16117@laptop.programming.kicks-ass.net>
References: <526DBD7F.1010807@gmail.com>
 <20131028131556.GN19466@laptop.lan>
 <526F2440.9030607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526F2440.9030607@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 08:58:08PM -0600, David Ahern wrote:
> To back out a bit, my end goal is to be able to create and merge perf-events
> from any context on a KVM-based host -- guest userspace, guest kernel space,
> host userspace and host kernel space (userspace events with a perf-clock
> timestamp is another topic ;-)). Having the events generated with the proper
> timestamp is the simpler approach than trying to collect various tidbits of
> data, massage timestamps (and hoping the clock source hasn't changed) and
> then merge events.
> 
> And then for the cherry on top a design that works across architectures
> (e.g., x86 now, but arm later).

Fair enough; but then I don't know how to get things faster than what
your initial patch proposes to do. Typically the only way to get things
faster is avoiding VM exits is by replicating state inside the guest,
but as you say, that ends up being complex/fragile.
