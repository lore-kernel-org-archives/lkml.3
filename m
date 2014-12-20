Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaLTUSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:18:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaLTUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:18:06 -0500
Date: Sat, 20 Dec 2014 12:18:01 -0800
From: Darren Hart <dvhart@infradead.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Message-ID: <20141220201801.GB16404@vmdeb7>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
 <20141220151108.GA11752@amd>
 <20141220161654.GA16404@vmdeb7>
 <12450702.GivQvxRsLB@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12450702.GivQvxRsLB@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 06:03:54PM +0100, Gabriele Mazzotta wrote:
> On Saturday 20 December 2014 08:16:54 Darren Hart wrote:
> > On Sat, Dec 20, 2014 at 04:11:08PM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > > Ok, I agree that it is subjective how serious it is...
> > > > > > Just to remind that patch fixing problem described in
> > > > > > 
> > > > > > http://www.spinics.net/lists/platform-driver-x86/msg05922.ht
> > > > > > ml
> > > > > > http://www.spinics.net/lists/platform-driver-x86/msg05924.h
> > > > > > tml
> > > > > 
> > > > > I don't have any objection to sending this back to stable.
> > > > > Stable is for fixing REAL bugs, as opposed to theorhetical
> > > > > races, etc. This is a "real" bug.
> > > > > 
> > > > > As to not chaning behavior, if it's OK for mainline, it's OK
> > > > > for stable. At least that is my understanding of it. Folks
> > > > > are free to verify with Greg if they disagree.
> > > > 
> > > > Darren, so how you decided? Now when patches are in linus tree, 
> > > > are you going to send them to stable tree?
> > > 
> > > Please don't. -stable is for serious mainline bugs people are actually
> > > hitting. Null pointer dereference counts, if people actually hit
> > > it. This is more behaviour change, and yes, the new behaviour is
> > > better, but it is really different class.
> > 
> > In this case I agree with Pavel. While the patches are small enough, fix one
> > thing each, etc, it isn't clear from the description exactly how these patches
> > affect users.
> > 
> > If you can articulate how they are "real bugs that bother people" (see
> > stable_kernel_rules.txt) we can reconsider. I should have pushed for better
> > commit messages on these it appears as this should be obvious from those, but it
> > isn't - at least not to me at 8:15am ;-)
> 
> The problem is that userspace programs responds to those keypresses when
> they shouldn't.
> 
> In case of KEY_KBDILLUMTOGGLE, the illumination level is changed by the
> BIOS, so if the keypress is reported, userspace programs will try to
> toggle the keyboard illumination after the BIOS changed the level.
> This is even more problematic if you consider that there could be
> multiple illumination levels that are not taken into account if a
> KEY_KBDILLUMTOGGLE is sent. Userspace will simply turn ON/OFF the
> illumination, interfering with the BIOS.
> This is shouldn't be a major problem since dell-laptop can control the
> keyboard illumination only now and I can't see what userspace
> application can misbehave without this change.

Agreed, this one should not go back to stable.

> 
> In the case of KEY_WLAN/KEY_RFKILL, the BIOS already takes care of
> everything when the key is pressed, so sending keypresses as if
> userspace programs have to do something is wrong. If for instance the
> WiFi rfkill is soft blocked and I press the Fn key twice, I want it
> to be soft blocked at the end. However, this is not the case.

These sound like good candidates, real bugs that bother people. I would support
sending them back to stable.

Since we didn't have this discussion before they went mainline, sorry it's been
a bad month for me :-/, these need to be sent manually. Pali, Gabriele, please
have a look at stable_kernel_rules, determine how far back these should go, and
submit the patches to the stable list.

> Sorry for the brief commit messages.
> 

They didn't bother me at the time as I saw the improvement, but they weren't
enough to make the stable decision and I need to watch out for that in the
future. Lesson learned :-)

Thanks everyone,

-- 
Darren Hart
Intel Open Source Technology Center
