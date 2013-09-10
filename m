Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab3IJTPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:15:41 -0400
Received: from mail.eperm.de ([89.247.134.16]:43860 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab3IJTPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:15:40 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Tue, 10 Sep 2013 21:15:31 +0200
Message-ID: <5317230.pU1YQUx7Id@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130910182524.GE29237@thunk.org>
References: <10005394.BRCyBMYWy3@tauon> <2722901.IcH4JOB8ab@tauon> <20130910182524.GE29237@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 10. September 2013, 14:25:24 schrieb Theodore Ts'o:

Hi Theodore,

>
>Also note that the clocksource is not necessarily be the best choice;
>it may not be the most fine grained sampling that we have available
>(that is certainly be true for MIPS).  So doing something hacky
>doesn't absolve us from the need to example every single platform that
>as a no-op get_cycles() function.  (Well, at least those platforms
>that we think really are going to be running security sensitive
>systems ---- does anyone think we really have production systems
>running m68k?  Maybe, but....)

That is why I arranged the clocksource call after get_cycles does not 
return anything, so it would only be used if get_cycles does not have 
anything.

But then, your experience with clocksource really has a point.
>
>If we believed that /dev/random was actually returning numbers which
>are exploitable, because of this, I might agree with the "we must do
>SOMETHING" attitude.  But I don't believe this to be the case.  Also
>note that we're talking about embedded platforms, where upgrade cycles
>are measured in years --- if you're lucky.  There are probably home
>routers still stuck on 2.6, at which point they will be far more
>succeptible to the problems described at http://factorable.net.

The core problem I guess on this matter is again the strange use of 
/dev/random in embedded devices -- no seeding, no spinning disks, no 
heads, no nothing.

Here my CPU jitter RNG would help, but there seems to be no interest in 
even discussing it... PS: I have my CPU jitter RNG running running as an 
entropy feeder daemon nicely on my router box, though, which happens to 
be a MIPS box...
>
>So I don't think we need to rush.  I'd much rather make sure we get
>this fixed right.
>
>					- Ted


Ciao
Stephan
