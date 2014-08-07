Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaHGRyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:54:20 -0400
Received: from mx3.wp.pl ([212.77.101.9]:18996 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaHGRyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:54:18 -0400
Date: Thu, 7 Aug 2014 19:54:15 +0200
From: Janek Kozicki <janek_listy@wp.pl>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, markus@gutschke.com,
        Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.16 crashes on resume from Suspend-To-disk
Message-ID: <20140807195415.03ca1027@absurd>
In-Reply-To: <20140806122548.GA10751@amd.pavel.ucw.cz>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
	<20140804141613.GB24261@amd.pavel.ucw.cz>
	<CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
	<11544482.e7kpiLjKfi@vostro.rjw.lan>
	<20140805115834.5e5e76f0@absurd>
	<20140806122548.GA10751@amd.pavel.ucw.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: $rkfae+2_DGd"-<Fvf,vE7&hL?oJC.uN!6/loh7NMwb/Cs*h!wXg0^+WL;VPwQ0]e0\sPi~63[g*K.:C@jj9zV:L^0&vNyT+aq.9L.0V'8yV%Q/PzmqW{8{/P`>BPR=BhRod2pTifbsp+}LY@O++;u~RqNMBFJgn?R{QHO^@4;?(l5x002ZHJ$zZd~:,H{5E&LV]7X9\7Bw*fl
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAALVBMVEUBAQEtLS1KSkpRUVFXV1dYWFhjY2Nzc3N3d3eHh4eKioqdnZ24uLjLy8vc3NxVIagyAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH2AIVEzgS1fgQtQAAAjRJREFUOMtt1DFv00AUAOAzFQNbjigSyoQaRaBMhKgLUyKXpVNNeUpk9vyDqFJhQ1kiBuaqAwJCqvPtSLY7RlTn5+5IdnYkkt/AOyfxXVLe5vf53Z1875kd34tOEax8djmj6GyjhB5bxz50GdsVZr9fqRjZwAtKOJw5Wqs2MMZ16ALHsaDncF7xAHix1oEFHAB8f+pRjcO4gfZDykcYzbiucRolOLUJ6kjA0xtVt+A6TySlM0RajIpK6DzwKZ/nOYbF/gclHMo1ZOHYY/+Ha+AWuM+3oMS4eeqYzZ8FiCltgUqI8cd2wwAVpJk+8LWYjBtnJdQpHQqJMd4Oxt4bU9ESiFGc5hkqaH74asAX4iabP5I5gZ+qjgGlJCqZa3h3lxhoeVcSE1qLQC4sqKOK9MGW9E3izFqqHokoztLFEgXg31sbZEKnWi2T74A4NxfVQqlkjKtcAWD+zcArFEES01dR0E/nnV0IgugmDd/2L84sOAouRBBHEc7gtc8teDkRlE0iNQPo2w3Xhh/D4TCIQ4LRLoTvgwjj6RRgavdurxYGMaIuGOyAW/PpNlCcU9/93AHenAWYjPoAwa+G3e3to/MgFNTAEKvKDjzuCzHTnY3qqdXtx24VijzQfZ0yewZ5cwRFQaa+mIYr1uI0I76+3W4xhlvoVRwOA0Fdl64HlJnxP6T8YpX/Lga4Wv4A3ErrU5oTfN7Mu/llXMl8RXEPji/lQkN3H7qXqgC2By47EXeU/7PJ/wPxRKMnuZwIeAAAAABJRU5ErkJggg==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [waPE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek said:     (by the date of Wed, 6 Aug 2014 14:25:48 +0200)

> On Tue 2014-08-05 11:58:34, Janek Kozicki wrote:
> > Rafael J. Wysocki said:     (by the date of Tue, 05 Aug 2014 03:30:58 +0200)
> > 
> > > On Monday, August 04, 2014 09:06:52 AM Markus Gutschke wrote:
> > > > Thanks for checking in. And no, I have not heard from Zhang since my
> > > > last e-mail. I suspect he is still working on finding a solution. But
> > > > you are of course right, reverting the patch in the meantime might be
> > > > a good idea.
> > > 
> > > It has too many dependencies.  Besides, reverting it now (at the beginning of
> > > a merge window) won't be particularly useful anyway.
> > > 
> > > We need to fix it.
> > 
> > 
> > Hi, sorry for hijacking this thread, but apparently my other plead
> > for help got ignored in this very busy mailing list.
> > 
> > I have an up-to-date recently installed debian wheezy. I downloaded
> > https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.xz and compiled it using:
> > 
> >   cp /boot/config-`uname -r` ./.config
> >   make menuconfig
> >   fakeroot make-kpkg --initrd --append-to-version=-vanilla.1 kernel_image kernel_headers -j38
> >   dpkg -i linux-image-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb linux-headers-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb
> > 
> > where .config was taken from debian /boot/config-3.14-0.bpo.1-amd64
> > 
> > my PC has 64GB of RAM, 32 Xeon E5-2687W cores and motherboard SuperMicro MBD-X9DRI
> > 
> > I just did 25 tries of suspend/resume cycle. I tried 4 different
> > methods of hibernation, you will find a full summary of my tries
> > (including how many failures for each method) in attached script
> > SLEEP.sh which I always used to perform hibernation.
> > 
> > The failure was always a reboot after resume had almost succeeded. In
> > cases when there was a success there was a following ---[cut
> >here]--- part:
> 
> The Intel audio driver seems to be requesting firmware... Can you
> rmmod snd_hda_codec_ca0132 and similar modules, and retry
> hibernation? 

Thanks a lot for your reply,

I did rmmod everything related to snd_hda_codec_ca0132 and then it
hanged during the suspend! There was something written on text
console, but I wasn't fast enough to photograph it. And I don't know
if it's written on the disk somewhere.

Now I'm following instructions from Rafael Wysocki and Takashi Iwai.
I hope these will help me getting out some useful debugging info.

-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
