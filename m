Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3JJGuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:50:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45553 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3JJGuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:50:23 -0400
Date: Thu, 10 Oct 2013 08:50:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20131010065017.GA1535@xo-6d-61-c0.localdomain>
References: <10005394.BRCyBMYWy3@tauon>
 <20130910150419.GA29237@thunk.org>
 <2722901.IcH4JOB8ab@tauon>
 <20130910182524.GE29237@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910182524.GE29237@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(Sorry to be late and maybe with very early date).

On Tue 2013-09-10 14:25:24, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 06:54:38PM +0200, Stephan Mueller wrote:
> 
> > Moreover, until having your proposed real fix, wouldn't it make sense to 
> > have an interim patch to ensure we have entropy on the mentioned 
> > platforms? I think /dev/random is critical enough to warrant some cache 
> > miss even per interrupt?
> 
> We are already mixing in the IP from the saved irq registers, on every
> single interrupt, so we are mixing in some entropy.  We would get more
> entropy if we had a good cycle counter to mix in, but it's not the
> case that we're completely exposed right now on those platforms which
> don't have get_cycles() implemented.  If the system running so lock
> step that the location of the interrupts is utterly predictable, then
> it's not clear that using a clock source is going to help you....

On the system with good power management and idle cpus (many of them), I'd
expect most of the IPs to be pretty much equal -- arch specific version of
"enter low power state" (mwait on recent intel machines, for example).

Would it make sense to mix the other registers, too?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
