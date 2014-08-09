Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaHIJ4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 05:56:49 -0400
Received: from mx4.wp.pl ([212.77.101.12]:35933 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaHIJ4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 05:56:47 -0400
Date: Sat, 9 Aug 2014 11:56:43 +0200
From: Janek Kozicki <janek_listy@wp.pl>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.16 crashes on resume from Suspend-To-disk, Intel pci_bus
 problem?
Message-ID: <20140809115643.5b124e87@absurd>
In-Reply-To: <s5hegwqghsu.wl%tiwai@suse.de>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
	<20140805115834.5e5e76f0@absurd>
	<20140805190709.2b19c10a@absurd>
	<140743930.1Lg0eFFrXs@vostro.rjw.lan>
	<s5h4mxo3aot.wl%tiwai@suse.de>
	<20140808182559.643f3b33@absurd>
	<s5hegwqghsu.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: $rkfae+2_DGd"-<Fvf,vE7&hL?oJC.uN!6/loh7NMwb/Cs*h!wXg0^+WL;VPwQ0]e0\sPi~63[g*K.:C@jj9zV:L^0&vNyT+aq.9L.0V'8yV%Q/PzmqW{8{/P`>BPR=BhRod2pTifbsp+}LY@O++;u~RqNMBFJgn?R{QHO^@4;?(l5x002ZHJ$zZd~:,H{5E&LV]7X9\7Bw*fl
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAALVBMVEUBAQEtLS1KSkpRUVFXV1dYWFhjY2Nzc3N3d3eHh4eKioqdnZ24uLjLy8vc3NxVIagyAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH2AIVEzgS1fgQtQAAAjRJREFUOMtt1DFv00AUAOAzFQNbjigSyoQaRaBMhKgLUyKXpVNNeUpk9vyDqFJhQ1kiBuaqAwJCqvPtSLY7RlTn5+5IdnYkkt/AOyfxXVLe5vf53Z1875kd34tOEax8djmj6GyjhB5bxz50GdsVZr9fqRjZwAtKOJw5Wqs2MMZ16ALHsaDncF7xAHix1oEFHAB8f+pRjcO4gfZDykcYzbiucRolOLUJ6kjA0xtVt+A6TySlM0RajIpK6DzwKZ/nOYbF/gclHMo1ZOHYY/+Ha+AWuM+3oMS4eeqYzZ8FiCltgUqI8cd2wwAVpJk+8LWYjBtnJdQpHQqJMd4Oxt4bU9ESiFGc5hkqaH74asAX4iabP5I5gZ+qjgGlJCqZa3h3lxhoeVcSE1qLQC4sqKOK9MGW9E3izFqqHokoztLFEgXg31sbZEKnWi2T74A4NxfVQqlkjKtcAWD+zcArFEES01dR0E/nnV0IgugmDd/2L84sOAouRBBHEc7gtc8teDkRlE0iNQPo2w3Xhh/D4TCIQ4LRLoTvgwjj6RRgavdurxYGMaIuGOyAW/PpNlCcU9/93AHenAWYjPoAwa+G3e3to/MgFNTAEKvKDjzuCzHTnY3qqdXtx24VijzQfZ0yewZ5cwRFQaa+mIYr1uI0I76+3W4xhlvoVRwOA0Fdl64HlJnxP6T8YpX/Lga4Wv4A3ErrU5oTfN7Mu/llXMl8RXEPji/lQkN3H7qXqgC2By47EXeU/7PJ/wPxRKMnuZwIeAAAAABJRU5ErkJggg==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [gZMk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai said:     (by the date of Sat, 09 Aug 2014 10:59:13 +0200)

> At Fri, 8 Aug 2014 18:25:59 +0200,
> Janek Kozicki wrote:
> > 
> > Full reply, along with CONFIG_PM_TRACE_RTC=y results is below.
> (snip)
> >
> > Now I tried to identify the problem. There are two magic numbers
> > recorded in realtime clock:
> > 
> > pci     0000:ff:0d.1: hash matches
> > pci_bus 0000:ff: hash matches
> > 
> > The 0000:ff: is strange, like no particular piece of hardware driver is wrong, but whole bus?
> > 
> > The 0000:ff:0d.1 from lspci is a following thing:
> > 
> > ff:0d.1 System peripheral [0880]: Intel Corporation Ivytown Unicast Registers [8086:0ee3] (rev 04)
> >         Subsystem: Super Micro Computer Inc Device [15d9:0628]
> >         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> >         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 
> > 
> > So that's the best I could do so far. Currently I am waiting for more
> > instructions from you on how to proceed.
> > 
> > PS: I am pretty sure that my hardware is not broken.
> 
> So, the PM hang problem still exists although the kernel WARNING is
> gone after the patch, right?

yes, exactly. Though it's not a hang, but a reboot.

>  Then the kernel WARNING was a red
> herring.  It should be fixed, but it wasn't the real cause of the
> hang.
> 
> I'll apply the patch to sound git tree in anyway, as it look like a
> right fix for kernel WARNING.

thanks a lot :-)

I hope to that this reboot in last stage of resume can be fixed :)


PS: it appears that my email account has problems dealing with so much
email traffic. I will monitor archives online in this thread, and
please reply both to mailing list and my email.
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
