Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3ARMNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:13:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54487 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3ARMNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:13:48 -0500
Date: Fri, 18 Jan 2013 14:13:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <tony@atomide.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/4] drivers: usb: phy: add a new driver for usb part of
 control module
Message-ID: <20130118121336.GE4672@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358502045-27008-1-git-send-email-kishon@ti.com>
 <1358502045-27008-2-git-send-email-kishon@ti.com>
 <20130118115909.GA4672@arwen.pp.htv.fi>
 <50F93B9C.108@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Content-Disposition: inline
In-Reply-To: <50F93B9C.108@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 18, 2013 at 05:40:04PM +0530, kishon wrote:
> >>+void omap_control_usb_host_mode(struct device *dev)
> >>+{
> >>+	u32 val;
> >>+	struct omap_control_usb	*control_usb =3D dev_get_drvdata(dev);
> >>+
> >>+	val =3D AVALID | VBUSVALID;
> >>+
> >>+	writel(val, control_usb->otghs_control);
> >
> >I would like to make this future proof too:
> >
> >val =3D readl(ctrl->otghs_control);
> >val |=3D OMAP_CTRL_DEV_AVALID | OMAP_CTRL_DEV_VBUSVALID;
> >writel(val, ctrl->otghs_control);
>=20
> I think we might then have to add
> val &=3D ~(IDDIG | SESSEND) right?

right, my bad ;-)

> >Another idea is to try to get the extra resource below, if it fails you
> >try to continue without it ;-)
>=20
> I prefer the way it is now because mailbox is needed for MUSB to be
> functional in OMAP4 and we should fail if we don't have it. No?

could be, that would mean an error on DT data though.

--=20
balbi

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+TxwAAoJEIaOsuA1yqREf3wP/3DadyomijyiBnlqtbkQe77p
v5lACwny7cdsddU3D652Zm+3HtER1NRK9nuePwVv1pkhUdt7bStpXrdcoq9b4Ipb
6jN7riVhcOmJ9YprM3QTmRou8iIX6eNd9xkXh+18M+nC4AC8s8xDRLCtZ1Sf9Mkh
fNf+MBBWCvX/NQxKov1TtZDB04BdkhCfsSE5J+2agkt57yCLVuGxFyHn3dKsiR3E
7Tw8z7gK84u7GZroN1mFHYVk9+HW/kSgi5bb0pace6DUFlZJ03RRVxy9ewQfuSC0
QcBYl/4fpeGwDmf5seJSo++x3QY2JxU4eMf7qWJvT93uxe1w5pGAWUvfpLeenowW
J3NU17nFa9VBP45tnkJED2iOGcX62X7hhSJwBEF1aMfRsQBvkaBFOFGwO3HKZgTP
YiNSUNHjGX1RxE2A0AMXU9GQrX1gpDTmMh4pYsNfolTRmXFsZIfgFIKSeZuLc/n1
Ua9D+trY5RDW99GF3iJVv0Vd4CMZB5rZiT9QmQgBLxZcHj2q2h9ulU4txcc+BCk6
i8FxtagOgU+5I7u1x+tRl3xU04gKFSsCksgozkTZLxeM9cnFn7G1gwOTzhJedixz
J9DiLXQwZJ162Tb4Eoj82U+vzb5EDTthChSh7jcHQCRQyrQT6YrFF2aTm/MWupl/
VT6FSlLUHJm6O4cZsxfg
=g3hQ
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--
