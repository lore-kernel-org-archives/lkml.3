Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaAUOtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:49:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46872 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaAUOs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:48:58 -0500
Date: Tue, 21 Jan 2014 08:47:25 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <george.cherian@ti.com>, <heikki.krogerus@linux.intel.com>,
        <rogerq@ti.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
Message-ID: <20140121144725.GF30451@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1390299099-14764-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pyE8wggRBhVBcj8z"
Content-Disposition: inline
In-Reply-To: <1390299099-14764-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pyE8wggRBhVBcj8z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 03:41:38PM +0530, Kishon Vijay Abraham I wrote:
> Since PHYs for dwc3 is optional (not all SoCs that have DWC3 use PHYs),
> do not return from probe if the USB PHY library returns -ENODEV as that

this isn't correct, they all have PHYs, some of them might not be
controllable.

> indicates the platform does not have PHY.

not really, that indicates the current platform tried to grab a PHY and
the PHY doesn't exist. If there's anybody with a non-controllable PHY
and someone gives me a really good reason for not using the generic
no-op PHY, then we should add a flag and we could:

	if (!likely(dwc->flags & DWC3_USB2PHY_DRIVER_NOT_NEEDED))
		dwc3_grab_phys(dwc);

But I really want to see the argument against using no-op. As far as I
could see, everybody needs a PHY driver one way or another, some
platforms just haven't sent any PHY driver upstream and have their own
hacked up solution to avoid using the PHY layer.

Your commit log really needs quite some extra work. What are you trying
to achieve ? Is this related to AM437x which doesn't have a USB3 PHY due
to the way the HW was wired up ? If so, please mention it. Explain how
AM437x HW was wired up, why it lacks a USB3 PHY and why we should
support it the way you want.

That sort of detail needs to be clear in the commit log, specially
considering the peculiar nature of AM43xx which uses a USB3 IP in
USB2-only mode, that needs to be documented in the commit log :-)

cheers

--=20
balbi

--pyE8wggRBhVBcj8z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS3oh9AAoJEIaOsuA1yqREkYAP/2VZ1tCp2VnzuTB+mNmb5Sm/
Ss4045EJYGv0QhkGmDwnoUEZoZWFpyWo+4h8+J7BpReNuVnF4nqyKX7MvB7Ivd7d
a8gAgebL26rpOfBTIlkdYduQxe/EM+95v+E9FQ/M0SKu36UwY93HEF8UnbjXHVsF
2kAYRQMTVoHN6GxP6P4MCNGyojfYMA8uevv/SFr+zTIJTt4/PM17Qsuq1xSMtzRl
YPzFDq1tNw+vXeF1IhpSjQ/UhIzOoG1D9Z88/e1CG1eosQQZWDTQDjYYTwhvMIyt
PtAHqoEXop0xzQ0Kj6T+7BGwLhu5Zh7tl4vg5veQ7OZSFmpZOmXyNlZ7OeLNRU5h
f+3Zj23x3JzDZb1KAxXXc8UYw5ITvF6x5zc82GFCQJgByO6u09vG7cAnKG+GrRiK
hQJE5sAxczwXmEfPEOh+PAVU06ie1phF5kjqMdVuLV2uVNftMksaiyarLTixlbKd
fryUujqB4oVD3/camDyq7K00zT+nVBE04hHdogtF6uw7GRaiy2eoLlPUSsdZp3V5
Z6IywNb1daTncXcSPTzyZs/osy6hdJuabkuh89WIoBefI23RHnyi4keK+bvUePZs
L6d0brIHl1zSOGJpx25SZIEEXeMr4rueXhqVG/CnbuE/zh77Pg4IAcMU/s6IDTzx
M8yyG98HI/VHlcUF1O9e
=CgjQ
-----END PGP SIGNATURE-----

--pyE8wggRBhVBcj8z--
