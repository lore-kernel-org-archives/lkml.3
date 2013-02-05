Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3BERlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:41:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59097 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888Ab3BERlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:41:16 -0500
Date: Tue, 5 Feb 2013 17:41:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>, Cyril Chemparathy <cyril@ti.com>,
        balbi@ti.com, Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        "Nair, Sandeep" <sandeep_n@ti.com>, Chris Ball <cjb@laptop.org>,
        Matt Porter <mporter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130205174113.GJ4720@opensource.wolfsonmicro.com>
References: <510FF1A6.403@mvista.com>
 <20130204164712.GB4269@arwen.pp.htv.fi>
 <510FF5C9.3030600@mvista.com>
 <20130204170216.GC4269@arwen.pp.htv.fi>
 <51100A72.6030909@ti.com>
 <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com>
 <5110369B.9060901@ti.com>
 <CACRpkda8xBB35CwuBH76xXcC341TeRs1ZuwzDD0LtuXc4ifQTw@mail.gmail.com>
 <20130205164705.GG4720@opensource.wolfsonmicro.com>
 <20130205170628.GD17852@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ai6NJizWfpRUKxSm"
Content-Disposition: inline
In-Reply-To: <20130205170628.GD17852@n2100.arm.linux.org.uk>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ai6NJizWfpRUKxSm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 05, 2013 at 05:06:28PM +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 05, 2013 at 04:47:05PM +0000, Mark Brown wrote:
> > On Tue, Feb 05, 2013 at 05:21:48PM +0100, Linus Walleij wrote:

> > > For IRQ mode, use the completion callback to push each cookie
> > > to NAPI, and thus let the IRQ drive the traffic.

> > The whole purpose of NAPI is to avoid taking interrupts for completion
> > of transfers.  Anything that generates interrupts when NAPI is in
> > polling mode is defeating the point.

> Yes, but you're missing one very important point.  If your DMA engine
> is decoupled from the network device, and the DMA engine relies upon
> interrupts to queue further transfers to move data into RAM, then you
> have two options:

> 1. Receive these interrupts so you can update the DMA engine for
>    further data transfer.
> 2. Don't receive these interrupts, and cause the network device to
>    error out with a FIFO overrun because its DMA requests have not
>    been serviced. (which may raise an interrupt.)

There's still the third option of just implementing a non-NAPI driver,
though I guess we've now built so much infrastructure on top of NAPI
that it's still useful to pretend we can disable interrupts.

--Ai6NJizWfpRUKxSm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREUQyAAoJELSic+t+oim9meMP+wQGjHAZdn1AoszGg81XLikx
LBO6zM/qUNMedHR83X6Lu0YqpJlWvnFaALFCnL7y4uWZMGWr4vqE5ojTj8jVZeFq
Seb4cBErx87WQjOP7JIeT3CG1pIlNySfloTB+hECGO7chABjW7ZjrN1mVTTo9yAf
AvxZ9pQaSZkkyUPuF+goDzQM3aOihXME2rOEsWQ6UT5AG7Bm7hAA9UHs9rlK6VpB
hXG8HTwXU7if+B7ByH6q/IxxqutcM97WI5c0a6KwKaRzaIRCJBS/AHnxA/8EM+vR
RF223u9m9Xrp2xayhuv/Md0JwhP7q9vg/YQ7oPnFyKFmEKi6SKkAdR23zV8E2NAk
hUKf2z/s3az3BCOvtsZvAOx3crUo4CxOfHAlh+nfT1OZw7sHP769tjJP8rGXBbiO
yW2cyO+5KA/udw6B07U1Lj/ui7FoVhY8/dybQYNOGy6EGYj1gTjOUTG7kJFd+3WE
w4jOE3qRcZFKOtjV+bhXOyPaOnlj7KBcuNISUuPopIOzm5AY7sPgF5yI8rhE5W2m
qlle5WAwOxUpZXbHQUIfsXwc0EmgeChxZ2qH66AuQXvI3CoACqsOA3QvwGIOjdta
vRlztO3L/Cqeg3r6darqaoWrsqFTgqsGhai0L6L2ZF1krHfaW6VrvTmErG/vZixC
nc+otbZzByvTJvlO86dM
=TnkV
-----END PGP SIGNATURE-----

--Ai6NJizWfpRUKxSm--
