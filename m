Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaIDLge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 07:36:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48562 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaIDLgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 07:36:32 -0400
Date: Thu, 4 Sep 2014 13:36:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Miguel Oliveira <cmroliv@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: patch "staging: remove nokia_hp4p driver
Message-ID: <20140904113630.GA15407@amd>
References: <14094295422869@kroah.com>
 <20140830213022.GA17147@amd>
 <20140830220417.GA15000@kroah.com>
 <20140830224430.GA19622@amd>
 <B39194F7-2057-4D14-A3F7-EB6E73BF84F8@holtmann.org>
 <20140831095147.GB24601@amd>
 <4CA4FD0A-C167-4A12-A137-766CB3A2D5D5@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA4FD0A-C167-4A12-A137-766CB3A2D5D5@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> There are 3 major topics that needs addressing before this driver should come anywhere near upstream kernel again, staging or otherwise.
> >> 
> >> a) Convert to using device tree for device detection
> >> 
> >> b) Convert to using hdev->setup for firmware loading
> >> 
> >> c) Convert to using hdev->set_bdaddr and HCI_QUIRK_INVALID_BDADDR
> > 
> > I thought staging is for merging code to be cleaned up. Not "please
> > rewrite, and possibly break the driver before merging it into
> > staging". Merge it into staging, then clean it up there.
> 
> The staging tree is for drivers to eventually go upstream. Staging is not a long term solution for a driver. It never was and never will be. So cleanup means whatever is required to get it upstream. And that means that you need to rewrite pieces.
> 
> For example a WiFi driver that ships its own 802.11 stack will never get upstream unless you re-write it to use mac80211.
> 
> > (Also hopefully get some testing from n900 community; code is more
> > visible in staging).
> 
> The problem is that they are testing the wrong thing. And lets face it, we already knew this driver works since Nokia shipped it in products.
>

Testing is still useful after major changes, like changes you are
asking me to do.

> > And BTW it is first time I hear about a).
> 
> So the whole ARM community is moving over to DT and you are ignoring it. I complained about the platform data before. Someone told me that the N900 will be converted to DT. So I assume that this driver will also use DT then. If that was not clear, then now I made it clear.
>

Point noted.

> > And yes, this driver bitroted a lot while being out of tree. It was
> > probably pretty good initially, mergeable with minimum effort. Now you
> > want it to bitrot a bit more.
> 
> Back in the days it was hard to merge since most of the OMAP stuff it depends on was not upstream. That why it never made it there. In addition that you need to build for specific OMAP boards makes it really hard to just take the driver. If it would have compiled on x86, I bet it would already been upstream.
> 

Compiling for omap is really simple, testing is not.

> >> The reason why it ended up in staging is that the 3 core problems needed fixing. And 8 month later they still have not been fixed.
> >> 
> > 
> > I attempted hdev->setup conversion, but could not figure it out till
> > now. Clearly it needs to be done.
> > 
> > For doing that, it would be good to have userland to work with, and
> > yes it takes time. (Debugging on 4" screen sucks.)
> 
> Actually hdev->setup does not need any userland. As long as request_firmware() works, you are just fine. And since the driver already uses that in the first place, I assume it works.
>

Yes, I do need userland for debugging. The screen is 640x480, and I
don't have shift-pageup, so not enough screen space to debug without
userland. And no serial port.

If the hardware was available for x86 or suitable development board,
yes, development would be easier.

> The Nokia firmware files have been sequences of HCI commands since forever. And I pointed you towards __hci_cmd_sync early on. And we have good examples of that in use already.
>

Do you have an example of conversion to __hci_cmd_sync()? I that is
what would help here.

> >>> You asked for more work and explained how easy it is to revert the
> >>> removal.
> >>> 
> >>> I did more work, you ignored it, and are removing the driver, anyway.
> >> 
> >> I have seen only fluff patches. Someone needs to address the core problems of the driver.
> > 
> > Clearly. But at the same time not taking even the trivial patches is
> > great way of stalling the devopment.
> 
> I do not maintain staging. However in this specific case there were pretty clear instructions on what needed changing. You can check for yourself on how much got addressed.
> 

You are not maintaining staging, so the driver in staging is no
additional work to you. Yet you insist driver must be removed,
creating additional work for me. When I pointed out that your reasons
for removal are actually untrue (patches were submitted), you point
out that you are not staging maintainer.

So, do you want to take responsibility for drivers/staging/nokia_h4p
or not?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
