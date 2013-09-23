Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3IWQUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:20:55 -0400
Received: from longford.logfs.org ([213.229.74.203]:57961 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3IWQUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:20:54 -0400
Date: Mon, 23 Sep 2013 11:02:22 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?utf-8?Q?J=C3=B6rg-Volker?= Peetz <jvpeetz@web.de>,
        John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130923150222.GA13764@logfs.org>
References: <20130916154026.GA23345@logfs.org>
 <20130921212510.GD8606@thunk.org>
 <20130921214118.GE8606@thunk.org>
 <20130922030553.GA21422@thunk.org>
 <523F5AB6.8070107@web.de>
 <20130922212752.GB7321@thunk.org>
 <20130922205334.GC4584@logfs.org>
 <20130922233641.GE7321@thunk.org>
 <20130923001623.GD4584@logfs.org>
 <20130923024338.GF7321@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130923024338.GF7321@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 September 2013 22:43:38 -0400, Theodore Ts'o wrote:
> On Sun, Sep 22, 2013 at 08:16:23PM -0400, Jörn Engel wrote:
> > How about we switch between the two mixing functions depending on the
> > interrupt load?  If this CPU has seen fewer than 1000 interrupts in
> > the last second, use the better one, otherwise us the cheaper one?
> 
> I guess the question here is whether it's worth it.  On a 2.8 GHz
> laptop Ivy Bridge chip the numbers are:

Then let us assume for now it is not worth it.  When I finally get
around to generating profiles for my insane system we can revisit the
issue.

> I am very strongly of the opinion that the number of systems where you
> have an embedded system with that kind of inane interrupt rate is the
> 0.00000000001% case.

That would be one machine in 10^13?  I doubt we have reached 10^13
machines running Linux in all of history, so a single example would
defeat your very strong opinion. ;)

Anyway, let me collect some real numbers before we argue any further.
And thank you for your maintainership.  It may not appear that way,
but I have _very_ little to complain about in drivers/char/random.c.

Jörn

--
One of the painful things about our time is that those who feel certainty
are stupid, and those with any imagination and understanding are filled
with doubt and indecision.
-- Bertrand Russell
