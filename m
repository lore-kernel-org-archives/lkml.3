Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3CNOIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:08:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45595 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab3CNOIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:08:46 -0400
Date: Thu, 14 Mar 2013 16:08:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Roger Quadros <rogerq@ti.com>, Felipe Balbi <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 11/12] USB: ehci-omap: Try to get PHY even if not in PHY
 mode
Message-ID: <20130314140832.GH26080@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363085090-24676-12-git-send-email-rogerq@ti.com>
 <Pine.LNX.4.44L0.1303121155540.2153-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6cMF9JLEeZkfJjkP"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1303121155540.2153-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6cMF9JLEeZkfJjkP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2013 at 11:57:56AM -0400, Alan Stern wrote:
> On Tue, 12 Mar 2013, Roger Quadros wrote:
>=20
> > Even when not in PHY mode, the USB device on the port (e.g. HUB)
> > might need resources like RESET which can be modelled as a PHY
> > device. So try to get the PHY device in any case.
> >=20
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > CC: Alan Stern <stern@rowland.harvard.edu>
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>=20
> >  		/* get the PHY device */
> >  		if (dev->of_node)
> >  			phy =3D devm_usb_get_phy_by_phandle(dev, "phys", i);
> >  		else
> >  			phy =3D devm_usb_get_phy_dev(dev, i);
> >  		if (IS_ERR(phy) || !phy) {
> > +			/* Don't bail out if PHY is not absolutely necessary */
> > +			if (pdata->port_mode[i] !=3D OMAP_EHCI_PORT_MODE_PHY)
> > +				continue;
> > +
> >  			ret =3D IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
> >  			dev_err(dev, "Can't get PHY device for port %d: %d\n",
> >  					i, ret);
>=20
> Felipe, this is a strange interface.  Why do we sometimes get an=20
> error-pointer and sometimes get just NULL?  Why not always an=20
> error-pointer?

looks like we get NULL when PHY layer is disabled. Sounds like an
oversight to me. Do you want to send a patch, or do I cook one and put
yourself as Reported-by ?

--=20
balbi

--6cMF9JLEeZkfJjkP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQdngAAoJEIaOsuA1yqRE714P/iT6BVFaP3kAzslEGu1ZzOSQ
9IUvWbpjPHdwn7D0Nrnno0u7R9OZHWNPl7hI+be4V/8qbqKtpJpKmfYQisPYEHzS
Wk5HPVOIQzgoWODFp5+afYpbyOuMBTpwZm5zrHPkVVGv94Gsxmk1/x3/buaDgUg0
0ycXRP0Z+SRa0uSIV3mF5oSILFjWoA4flppCWBCFTBjubLUHOCcbMCs6tPEA4J6j
ep7a5dQUDoLj7a1tKbM55ZSPSdGhj/Uwvxh9/r1tP6I2tkmasQ0R4u235JSQ7vDH
iXEXR3Yfm1S+7jGC7iiK/T/UUTU9sk46H8HqzG3xPNFhHdZxuDE2s0hECpXu85sd
j/rELZBhlh2+tYMNBmS/piKFOoEVM3ODuwccZLnmDqreTzpMy6xnQdZI9jGKnDxw
bVSAIC/6o1bjXCndCy7kH2E3l3g+7u+NmuV7+6oWVNBz27iHnLUzLEVLIOpiQs2p
FirC9NjHTW815oPB9Fpo+KJY55zeZLFb7bNsHlWFvmqJwIqHDvFipBSTusl3d+W4
IDeqinZC27I8D+5bIr7Z8bUnOMvwFV1++6/KQoqdlYoRPdYbtGrXRL1JEKcJfr0Z
pqw8JDJ/4eFbtemirGHpwzJtflB+Bk7A9P1TCV33yXHpgb8r5E4wnqPuO30Jct8u
BktaECJHo+BCO0+6rFtE
=jd80
-----END PGP SIGNATURE-----

--6cMF9JLEeZkfJjkP--
