Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3KBLM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 07:12:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42736 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3KBLM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 07:12:26 -0400
Date: Sat, 2 Nov 2013 12:12:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131102111224.GA19388@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon>
 <3160817.9DcncHidey@tauon>
 <20131029132448.GB691@thunk.org>
 <7861469.OAmn4h8An0@tauon>
 <20131102110112.GA16231@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131102110112.GA16231@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-11-02 12:01:12, Pavel Machek wrote:
> Hi!
> 
> > >sense of where the unpredictability might be coming from, and whether
> > >the unpredictability is coming from something which is fundamentally
> > >arising from something which is chaotic or quantum effect, or just
> > >because we don't have a good way of modelling the behavior of the
> > >L1/L2 cache (for example) and that is spoofing your entropy estimator.
> > 
> > Please note: if the jitter really comes from the oscillator effect of 
> > the RAM clock vs. the CPU clock (which I suspect), we will not be able 
> > to alter the jitter software wise.
> 
> Well... if it is really oscillator effect, there should be _no_
> entropy when running with L1/L2 enabled (because DRAM will not be
> accessed at all at that case).
> 
> There should be way to extract entropy more directly from various
> oscillator effects, no?

Actually... bogomips calibrating loop already has jitter, measured
from difference between CPU clock and system clock... Could that be
used as entropy source? As a bonus, we should have it on most
platforms...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
