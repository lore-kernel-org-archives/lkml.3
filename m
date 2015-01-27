Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbbA0TtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:49:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36717 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbbA0TtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:49:21 -0500
Date: Tue, 27 Jan 2015 19:49:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20150127194912.GO21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-9-git-send-email-ricardo.ribalda@gmail.com>
 <20150127000428.GK21293@sirena.org.uk>
 <CAPybu_1RW0F-ak-B_4H-riTUwF2yCrpKdT2RWviTdCMR_kQmww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uugJhu2tcv2n65vm"
Content-Disposition: inline
In-Reply-To: <CAPybu_1RW0F-ak-B_4H-riTUwF2yCrpKdT2RWviTdCMR_kQmww@mail.gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/18] spi/xilinx: Support cores with no interrupt
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uugJhu2tcv2n65vm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 08:05:57PM +0100, Ricardo Ribalda Delgado wrote:

> > Right, for short transfers polling tends to win every time over
> > interrupts - if you look at other controller drivers you'll see a lot of
> > them use this technique.  The best practice here is generally to use a
> > copy break and do very short transfers in polling mode and go back to
> > interrupts for larger ones.  This break is typically done at the point
> > where we go over a FIFO in transfer size since normally if the device is
> > designed to be run with DMA the FIFO will be quite small.

> Seems very reasonable. Only problem I can see is if the spi clk is
> veeery slow, then a irq approach, even for transfer size bellow
> buffer_size will be better.

Yeah, there's a bit of guesswork in there though practically speaking
people tend not to make SPI *that* slow since one of the reasons to use
it over I2C is performance.  You can do things like estimate how long
the transfer should be based on the clock rate and shove a msleep() in
there as well.

> > Obviously this isn't quite the same case since not only is there no DMA
> > support (yet?) but the FIFO could be any size but similar things apply
> > especially if someone configured the device with a large FIFO.

> The hardware does not support dma (at least without making use of
> another core called cdma....)

Yes, that's standard - it's very rare to see a SPI controller with
integrated DMA.  Usually the IP will bring out signals which can
handshake with a DMA controller to control flow.

> We can always argue that the system engineer can select polling by not
> specifying an irq on the device tree.

The DT should describe the hardware, performance tuning doesn't really
come into that - what if the driver gets better and can be smarter about
interrupts or the best tuning varies at runtime?

> >> +     xspi_init_hw(xspi);

> > This appears to move the interrupt request before the hardware reset.
> > Are you sure the interrupt handler won't misbehave if it fires before we
> > finished initializing?  One thing the hardware reset should do is get
> > the device in a known good state.

> The hardware will be reseted and in good state by the function
> find_buffer_size, so this should be good. Also the initialization is
> slightly different for polling and irq mode.

> So far I have fixed what you have sent and implemented a new patch for
> the "heuristic" irq mode. I will try to run in on hw tomorrow and send
> a new patchset with the patches that have not been merged yet.

OK.

> Maybe you want to consider also this patch from Michal Simek to your
> topic/xilinx branch

> https://patchwork.kernel.org/patch/5648351/

Please include plain text descriptions of things in your mails rather
than just links/numbers.

--uugJhu2tcv2n65vm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx+u3AAoJECTWi3JdVIfQd0wH/39w/4VhBshJwqC81/J6XIWj
Qg01hxnY3u3NTxUk/IqCkHzrcobZ8R3fvNwDuH8m3QtN51CCQt17TlkCmeoLaUP2
CV/XstQZ9Xyq+yKuWmPXTI5BFVPl6tW40ZW/8Uu1tydv0zg43KVRBki/UfKOz+uY
UeiebbNsVUQuMUueqoFwkJbHbQK37Ubg9/eFCeyL0rR1zurxgEuISTAbRJlf8OJT
BxPcIFW4qTeCL4TQ3Hnxi30bqpcBcnYiFf+w82SNDwZoS73b9i93kij9UhHWtoht
/LfYCm5GwbbjX0FVEeUCUWBBoQeMADFOLC/MDluSpuxImsOYaEBHg9B4M04H0WI=
=Pg5B
-----END PGP SIGNATURE-----

--uugJhu2tcv2n65vm--
