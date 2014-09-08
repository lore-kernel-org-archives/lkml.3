Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaIHHJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:09:44 -0400
Received: from ozlabs.org ([103.22.144.67]:47785 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaIHHJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:09:43 -0400
Date: Mon, 8 Sep 2014 17:09:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>, Stefan Agner <stefan@agner.ch>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20140908170934.34b1e4cf@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kjHVBc/l42B4OmzqX3jFXDc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kjHVBc/l42B4OmzqX3jFXDc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/phy/phy-mxs-usb.c between commit 43f3634ff7e2 ("usb: phy:
mxs: add imx6sx support") from the usb.current tree and commit
d0ee68b59e6a ("usb: phy: mxs: Add VF610 USB PHY support") from the
usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/phy/phy-mxs-usb.c
index 00972eca04e7,8c2f23b75d6d..000000000000
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@@ -125,13 -125,12 +125,18 @@@ static const struct mxs_phy_data imx6sl
  		MXS_PHY_NEED_IP_FIX,
  };
 =20
 +static const struct mxs_phy_data imx6sx_phy_data =3D {
 +	.flags =3D MXS_PHY_DISCONNECT_LINE_WITHOUT_VBUS |
 +		MXS_PHY_NEED_IP_FIX,
 +};
 +
+ static const struct mxs_phy_data vf610_phy_data =3D {
+ 	.flags =3D MXS_PHY_DISCONNECT_LINE_WITHOUT_VBUS |
+ 		MXS_PHY_NEED_IP_FIX,
+ };
+=20
  static const struct of_device_id mxs_phy_dt_ids[] =3D {
 +	{ .compatible =3D "fsl,imx6sx-usbphy", .data =3D &imx6sx_phy_data, },
  	{ .compatible =3D "fsl,imx6sl-usbphy", .data =3D &imx6sl_phy_data, },
  	{ .compatible =3D "fsl,imx6q-usbphy", .data =3D &imx6q_phy_data, },
  	{ .compatible =3D "fsl,imx23-usbphy", .data =3D &imx23_phy_data, },

--Sig_/kjHVBc/l42B4OmzqX3jFXDc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDVY0AAoJEMDTa8Ir7ZwVCIAP/iSqdZ9mFOP1E45gPWj/mE1y
zSyYTGneDVwbNUh247lSQsuXY9++8tAVM+wcjalNG9Ls6vuWN+ItCMCH25EYcGto
GNFlrX1M26pibGn9bfBvo7gjBe/PVDMC1z311EjH6d0Rpd6C46nvo7pHGru6V0QS
eXmoU43NPFLjqSfdZuZQqoA5AI5EeGFN0hp2lGT+11IejNemBp9LM5TMCBcmecX8
qkVxbyVm5lIFpEcdzIHVwIy965vG0xbbbHUR5FlpGQCLEygxKgGpHL2cd5hatpkv
7SOy72PzYnBi1roMdmM3HDUAv8PNFf5BGF4+tQzJHdCU+ovRBRzgpl30LBhawER8
YIORnawS0x5QgrzkGS95lepvJqRIuNDw5ItenVOgs4HfFBjVtl/suJ2Hs9otJqJc
qmV5p2yIWicjo3pJJBcmEo1Z6trQ3FEsKBy1CnDa00VBUCBuw2jwBuwIZIEW03Ds
WsB/TANO1trIieBDQSgitOJHYUv2o9dLz31sK/8xe+FZGoB7mSMN0sSnYxs86foZ
NdRImpSFeNSUONEs2qrhs18pR2AJXY3u7JA+eFUa/6hxayOGxE0J7jWSuCoKzFmJ
jT0uLWisKVRbBrBqZIcOP1fCOHIg+E9RuEGj2dn2SbHoiL4lhJvNfF10SacfdwLA
dQBWr6TwkjaP1UsCgr5e
=Wo+5
-----END PGP SIGNATURE-----

--Sig_/kjHVBc/l42B4OmzqX3jFXDc--
