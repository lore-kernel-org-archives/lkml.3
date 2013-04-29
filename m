Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab3D2UpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:45:08 -0400
Received: from relais.videotron.ca ([24.201.245.36]:65180 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab3D2UpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:45:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 29 Apr 2013 16:45:05 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
In-reply-to: <CA+55aFzLtBwsvVrnT2DrUOU+eYrQ5eiKeamRb4Y5+-TVgbuM5Q@mail.gmail.com>
Message-id: <alpine.LFD.2.03.1304291605070.17372@syhkavp.arg>
References: <20130429162115.GA6893@kroah.com>
 <CA+55aFz7bESS-T2_5vndVEzbk7ocmfEanBO+sviTSNekOLKRcg@mail.gmail.com>
 <20130429183851.GA8106@kroah.com>
 <CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
 <CA+55aFzLtBwsvVrnT2DrUOU+eYrQ5eiKeamRb4Y5+-TVgbuM5Q@mail.gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Linus Torvalds wrote:

> The "explanations" for why it should be in drivers/ is this mindless drivel:
> 
> On Tue, Feb 22 2011, Daniel Walker wrote:
> > On Tue, 2011-02-22 at 12:47 -0800, Dima Zavin wrote:
> >
> >> What is the problem leaving it under arch/arm/mach-msm?
> >
> > Because it's a driver.
> 
> Seriously. That's the *ONLY* explanation given.

This certainly sucks as an answer.

> WTF? That's a singularly *bad* reason for moving things to "drivers".

Agreed.

> And I'm calling the ARM people out on this idiocy. Arnd and Nico -
> stop encouraging this kind of crap. Move things to drivers only once
> there is actual reason for it. If it's some proprierary single-SoC
> thing, it can damn well stay away from other people. And it definitely
> shouldn't mess up autocomplete in some core location.

All I wish to add to what Arnd already stated is this:

We ought to gather drivers together according to their _purpose_.  
Especially if they provide some generic functionality via a common API 
to be used by the rest of the kernel.  In some cases that API just begs 
to be created and commonalities factored out from individual drivers, 
which also warrants a move to drivers/.

Of course the cpufreq drivers, or even the cpuidle drivers, are awfully 
platform specific, or even proprietary single-SoC in many cases.  But 
the interface they register into and the services they provide are 
common, and it is far easier for someone maintaining the cpuidle 
infrastructure to improve the interface and avoid conflicts by having 
all the related drivers at the same place. .  It even helps next driver 
author look for better examples than only the last SoC they worked with.

However this is a design goal, not a hard rule.  If a piece of code has 
no interface commonality with anything else then it is indeed not worth 
the hassle.


Nicolas
