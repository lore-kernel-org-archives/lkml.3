Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaFXLNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:13:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55556 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaFXLNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:13:08 -0400
Date: Tue, 24 Jun 2014 12:12:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Message-ID: <20140624111249.GK23300@sirena.org.uk>
References: <1403033795-9122-1-git-send-email-mpa@pengutronix.de>
 <20140618001127.GC5099@sirena.org.uk>
 <20140618210159.GC32450@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2pR2RtFp0tAjF3C"
Content-Disposition: inline
In-Reply-To: <20140618210159.GC32450@pengutronix.de>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Add Kconfig option for debugfs register writes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2pR2RtFp0tAjF3C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 18, 2014 at 11:01:59PM +0200, Markus Pargmann wrote:
> On Wed, Jun 18, 2014 at 01:11:27AM +0100, Mark Brown wrote:

> > This is deliberately hard to enable in order to make it clear that it
> > should never, ever be used in production as a bodge around writing
> > drivers and generally in order to reduce the risk to the rest of the
> > system.  Enabling this will typically give userspace full access to
> > components like PMICs which have the potential to cause physical damage
> > to the system if misused.

> The userspace already has full access to all those registers if you
> want. For example memory mapped registeres can be written through
> /dev/mem. I2C registers can easily be changed using i2c-tools or the
> /dev/i2c-* devices. So you are already able to write a userspace driver
> if you really want to.

Right, but in all cases except for /dev/mem the API ensures that you
can't simultaneously run a kernel and userspace driver.  It's not the
userspace driver bit that's the problem but rather having both at the
same time.

> I think this kconfig option would make it easier to debug hardware or
> driver issues, as it is much more comfortable to have a clean kconfig
> option.

Well, a major goal of doing things this way is to make it seem wrong to
be using this too much!  :P

--J2pR2RtFp0tAjF3C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqV0tAAoJELSic+t+oim9PWcP/AznBc02Gdk1ZGkquMFBpaiw
1Gekbdp5DCL46VM3MLLGm6o9a3I/NS+V1xyPSSIJZBQQOSy3Jo7qjH8dWOQaOkPg
syXOnWCyiQJPsCDDfWPJ5bv/Lgs+h5FA/jRevlim1SZLvln4Fr8bAY348l8rZgfv
4SFiHJGm0wZzXDHuydOFe84tDAUCKu0Na7eeFGHkxRSBBEUYHo8yGjNuBZ+A5Hjf
D7dZ6KT92t4kecBCn1WnRUY+yHL1wWa3A6ClkmS1VRlVFAMFiu9z7MRXTz6fc7d/
SrDusqauAxvHkde1/+jJGMFhxolCkokA7XAox1+3gpoSCgA4ybZcEP0MGqH6KqF6
Dmazwa+YkLye+XMgpZuKdeTnwL6JCuw9vxkmK7nBPOO3uHpoya7LIzP8OUy+WQMO
IWr4u8Z0m3gqkO0gZdQfctfEjO9EnYcn8IlHsWym5cBS4Vb1YUEcT4dSYeDy0MWB
3Cblj+UlTZleVnZ1d/u+qr3vT+4NMRy0Z+dMh/JisWkSiElFGf3snlai88HVkoMC
9Z15Tm1mJ9Cl1YXuIJOK4o3i69OZAVgnnvrlW7IMtKm8Lnhkbyxt7m87bplKcAPZ
ZeUue982PoxHCori8XELVvWe38qVrOF0eucKlI2g1byY+9tD4MdsSmVKAIz5od/W
tfLngHB9DrVykRL2tSc7
=Tm2j
-----END PGP SIGNATURE-----

--J2pR2RtFp0tAjF3C--
