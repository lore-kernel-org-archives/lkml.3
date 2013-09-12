Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3ILXcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:32:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:59306 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab3ILXcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:32:07 -0400
Date: Thu, 12 Sep 2013 19:31:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130912233155.GB5279@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <10005394.BRCyBMYWy3@tauon>
 <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
 <20130910203853.GG29237@thunk.org>
 <522F851D.1040101@linaro.org>
 <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130912210717.GC3809@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:07:17PM -0400, Jörn Engel wrote:
> 
> I happen to have a real-world system with >100k interrupts per second
> and - surprise - add_interrupt_randomness() showed up prominently in
> the profiles.  I was also told twice to just remove that call.  I
> resisted both times and have done far more work to reduce overhead
> while still collecting entropy.  Some others would have caved in.

Would it be possible for you to send me the perf numbers that you saw?

What platform is this?  x86?   Some embedded processor?

> One option is to add the "input_pool.entropy_count > trickle_thresh"
> condition that all other entropy sources currently have.  But instead
> I would rather rename fast_mix() to not_too_fast_mix() and implement a
> real fast_mix().  Essentially just xor the collected numbers into a
> pool and schedule something to shuffle the bits at a later point.

We can try some different things to make fast_mix() faster, but it
would be good to get some hard numbers before we start deciding we
need to do something more complicated.

One thing that comes to mind is that fast_mix() is only called in
exactly one place, and we always pass in a long.  So there are
certainly ways that we could optimize fast_mix even keeping the
current mixing algorithm.

Cheers,

						- Ted
