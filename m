Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaJTWDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:03:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57576 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaJTWDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:03:41 -0400
Date: Tue, 21 Oct 2014 00:03:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        kishon@ti.com, s.nawrocki@samsung.com
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141020220338.GA19314@amd>
References: <20141019090107.GA19132@amd>
 <201410191658.45851@pali>
 <20141019205033.GA4738@amd>
 <201410192300.20625@pali>
 <20141020130855.GA1067@amd>
 <20141020164542.GD5192@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020164542.GD5192@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-10-20 09:45:42, Tony Lindgren wrote:
> * Pavel Machek <pavel@ucw.cz> [141020 06:10]:
> > Hi!
> > 
> > > My N900 can boot kernel from v3.12-rc5-n900 branch compiled with 
> > > arch/arm/configs/rx51_defconfig. Also it can boot full Maemo5 
> > > system (with CSSU and some minor system changes) and usb network 
> > > via g_nokia.ko gadget working fine...
> > > 
> > > So if it does not working for you then kernel usb subsystem could 
> > > have problems with using gadgets directly from zimage.
> > 
> > After some hand-bisecting and real-bisecting, I found two commits that
> > cause problems for 3.13: With these reverted, I get usb networking
> > back in 3.13 on nokia n900.
> > 
> > (Pali, if you revert these, you should get working usb networking in
> > your 3.13 branch, too.)
> > 
> > Any ideas?
> 
> Hmm maybe check if current stable kernels work for you without
> reverting anything ? Few weeks ago I did the the following two fixes
> with cc stable v3.13+:
> 
> 96be39ab34b7 usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
> 85601b8d81e2 usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down

I tried these on top of 3.14 (where my revert fixes stuff) and no, it
does not seem to help. (Trying stable would be a bit more work).

Do you want me to try on 3.13, too?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
