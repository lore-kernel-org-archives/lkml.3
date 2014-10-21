Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbaJUVwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:52:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41266 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbaJUVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:52:53 -0400
Date: Tue, 21 Oct 2014 23:52:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        kishon@ti.com, s.nawrocki@samsung.com
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141021215250.GA20087@amd>
References: <20141019090107.GA19132@amd>
 <201410191658.45851@pali>
 <20141019205033.GA4738@amd>
 <201410192300.20625@pali>
 <20141020130855.GA1067@amd>
 <20141020164542.GD5192@atomide.com>
 <20141020220338.GA19314@amd>
 <20141020222942.GA2560@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020222942.GA2560@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > After some hand-bisecting and real-bisecting, I found two commits that
> > > > cause problems for 3.13: With these reverted, I get usb networking
> > > > back in 3.13 on nokia n900.
> > > > 
> > > > (Pali, if you revert these, you should get working usb networking in
> > > > your 3.13 branch, too.)
> > > > 
> > > > Any ideas?
> > > 
> > > Hmm maybe check if current stable kernels work for you without
> > > reverting anything ? Few weeks ago I did the the following two fixes
> > > with cc stable v3.13+:
> > > 
> > > 96be39ab34b7 usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
> > > 85601b8d81e2 usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down
> > 
> > I tried these on top of 3.14 (where my revert fixes stuff) and no, it
> > does not seem to help. (Trying stable would be a bit more work).
> > 
> > Do you want me to try on 3.13, too?
> 
> Sounds like there's something else missing too then. Maybe give
> v3.18-rc1 and device tree based boot a try?

Ok, I tried 3.18-rc1 (with dt appended to the zImage) and this should
be the logs from that attempt (on PC).

[205583.689477] usb 4-1: Product: Nokia N900 (Update mode)
[205583.689480] usb 4-1: Manufacturer: Nokia
[205583.689483] usb 4-1: SerialNumber: 4D554D363434323537
[205584.467273] usb 4-1: USB disconnect, device number 72
[205590.120043] usb 4-1: new high-speed USB device number 73 using
ehci-pci
[205605.232034] usb 4-1: device descriptor read/64, error -110
[205620.448036] usb 4-1: device descriptor read/64, error -110
[205620.664032] usb 4-1: new high-speed USB device number 74 using
ehci-pci
[205635.776032] usb 4-1: device descriptor read/64, error -110
[205650.992032] usb 4-1: device descriptor read/64, error -110
[205651.208030] usb 4-1: new high-speed USB device number 75 using
ehci-pci
[205661.616025] usb 4-1: device not accepting address 75, error -110

IOW usb gadget driver loaded (or there would be no "new high-speed USB
device" message, but communication does not work.

I'm attaching the config.

> FYI, there's some PM support there too since v3.16-rc7, so using
> anything pre v3.17 is probably not fun on the battery. Well it works

My goal is to get nfsroot to work, and then I can play with bluetooth,
userland and power management. For now, power consumption is not
important, as I'm unable to boot useful system.

(I could boot from MMC, but that's too cumbersome to use due to lack
of space, hard communication, and constant fiddling with device
cover).

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
