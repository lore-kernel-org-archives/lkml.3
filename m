Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3KSMXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:23:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36713 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3KSMXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:23:31 -0500
Date: Tue, 19 Nov 2013 13:23:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, Dean Nelson <dcn@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131119122322.GM3866@twins.programming.kicks-ass.net>
References: <20131117080603.2a0d3b6d@notabene.brown>
 <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
 <20131119104438.6d45828b@notabene.brown>
 <20131119082548.GD10022@twins.programming.kicks-ass.net>
 <20131119195851.26bee8e6@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119195851.26bee8e6@notabene.brown>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 07:58:51PM +1100, NeilBrown wrote:
> 	/*
> 	 * TODO: Make sure that we wait at least required delay but why we
> 	 * have to extend it one tick more?
> 	 */
> 	schedule_timeout_interruptible(msecs_to_jiffies(delay) + 2);

What makes me sad is that clearly people knew stuff was broken but
somehow it never got properly fixed.

Yes, changing something like this is risky, but I prefer to fix the
implementation to the sane and documented behaviour and fix up whatever
fallout that generates. The end result is saner code in general and less
new bugs.

