Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205Ab3DJKGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:06:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60131 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765344Ab3DJKGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:06:24 -0400
Date: Wed, 10 Apr 2013 12:06:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20130410100620.GB16074@amd.pavel.ucw.cz>
References: <19040462.WFXWijAIDd@pali>
 <20130330183526.GA21198@lizard>
 <20130330214229.GA4322@amd.pavel.ucw.cz>
 <201303302351.06611@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303302351.06611@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Thanks for the review, Pavel! Although, the patch is in
> > > Linus' tree long ago. ;-)
> > 
> > Yeah... I did a bit of history-digging ;-). Now, I should
> > figure out how to put custom kernel on n900 _and_ keep it in
> > working state at the same time.
> > 
> > (I installed some kind of multiboot, then, apt decided to
> > install some u-boot extension. Then it got interesting. I
> > never got my own kernel to work, and u-boot magically
> > disappeared, but I still have working phone :-).
> 
> Hello Pavel,
> 
> here are some hints for booting 3.8+ kernel on n900:

Ok, I have compiled defconfig kernel (with patches, as indicated). 

sudo src/0xFFFF -m /data/l/linux-n900/arch/arm/boot/zImage -l -b

seems to boot it, I see kernel messages scrolling, but it reboots
instead of going to the GUI.

> "multiboot" package from Maemo Extras is horrible hack which can 
> be used only for booting maemo 2.6.28 kernel. it flashing new 
> kernel to n900 nand, then reboot device, start maemo init and 
> mount/chroot into new os dir... after reboot it erasing kernel 
> nand area where is normaly uboot placed, so do not install it!

I had it already :-(. Removed now. I tried running custom kernel, but
then multiboot interfered. I got u-boot installed with help from irc.

Unfortunately, the u-boot can not boot kernel-power, so I'm back to
original kernel without tethering :-(.

> uboot in Maemo Extras cannot boot 3.x kernels because autobuilder 
> (Extras server app for buidling packages) has very old gcc which 
> produced semi-(non)working uboot (can boot some 2.6 kernels).
> 
> my uboot builds compiled by gcc 4.7 (which can boot 3.8 kernel): 
> http://atrey.karlin.mff.cuni.cz/~pali/u-boot/

Can I get away with using  u-boot package in the repositories?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
