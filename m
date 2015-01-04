Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbbADUhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:37:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57643 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbADUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:37:31 -0500
Date: Sun, 4 Jan 2015 21:37:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: marc.zyngier@arm.com, rmk+kernel@arm.linux.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150104203724.GA16372@amd>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <20150104201026.GA23427@amd>
 <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2015-01-04 15:25:02, Nicolas Pitre wrote:
> On Sun, 4 Jan 2015, Pavel Machek wrote:
> 
> > On Sun 2015-01-04 15:03:02, Nicolas Pitre wrote:
> > > If that is still unacceptable to you for whatever reason, then the least 
> > > wrong compromize should be:
> > > 
> > > 	seq_printf(m, "BogoMIPS\t: 1.00\n");
> > > 
> > > That'D allow for those broken applications to run while making clear 
> > > that the provided value is phony. I was about to suggest 0.00 but that 
> > > could trigger a divide by zero error somewhere I suppose.
> > 
> > I don't know what 1.00 will cause, and neither do you, so what about
> > simply reverting the bad patch?
> 
> Because the patch wasn't "bad".  It did solve a recurring support 
> problem where people did actually complain on the list because the value 
> was not what they would have liked.  Removing this meaningless value did 
> actually fix that support issue as no more complaints came through for 
> the last 1.3 year, and is actually the only way for user space to be 
> fixed too.

People complain on the list, so what? People complain about systemd,
too. We ignore them.

Alternatively, just don't touch the bogomips computation. It is not
that much of maintainance burden. You can probably also get away with
replacing bogomips with actual cpu frequency.

Replacing it with 1 is asking for trouble.

See the links I quoted. Removing the value caused real problems. (And
I still did not hear so much as "sorry".) Now you propose to put
obviously wrong value in there, and claim it is not a
problem... because it takes time before someone debugs breakage you
want to cause.

https://www.google.cz/search?q=FATAL:+cannot+locate+cpu+MHz+in+/proc/cpuinfo&ie=utf-8&oe=utf-8&gws_rd=cr,ssl&ei=06OpVJWuIcPkUsOTgbAL

First 2 screens in google are full of poor folks debugging this
breakage.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
