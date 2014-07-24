Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187AbaGXGio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:38:44 -0400
Received: from ozlabs.org ([103.22.144.67]:43978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaGXGin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:38:43 -0400
Date: Thu, 24 Jul 2014 16:38:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <mat.krawczuk@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: linux-next: manual merge of the usb tree with the samsung tree
Message-ID: <20140724163834.430cf674@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/c_w9TM9BXeaI+tfo4eparA4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/c_w9TM9BXeaI+tfo4eparA4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/phy/phy-samsung-usb2.c between commit 949ccc3a9363 ("phy: Add
support for S5PV210 to the Exynos USB 2.0 PHY driver") from the samsung
tree and commit 016e0d3cb72c ("drivers: phy: exynos-usb2: add support
for Exynos 3250") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/phy/phy-samsung-usb2.c
index 29e4ab987645,ae30640a411d..000000000000
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@@ -87,12 -87,12 +87,18 @@@ static struct phy *samsung_usb2_phy_xla
  }
 =20
  static const struct of_device_id samsung_usb2_phy_of_match[] =3D {
 +#ifdef CONFIG_PHY_S5PV210_USB2
 +	{
 +		.compatible =3D "samsung,s5pv210-usb2-phy",
 +		.data =3D &s5pv210_usb2_phy_config,
 +	},
 +#endif
+ #ifdef CONFIG_PHY_EXYNOS4X12_USB2
+ 	{
+ 		.compatible =3D "samsung,exynos3250-usb2-phy",
+ 		.data =3D &exynos3250_usb2_phy_config,
+ 	},
+ #endif
  #ifdef CONFIG_PHY_EXYNOS4210_USB2
  	{
  		.compatible =3D "samsung,exynos4210-usb2-phy",

--Sig_/c_w9TM9BXeaI+tfo4eparA4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0KnwAAoJEMDTa8Ir7ZwVKUcP/j/uNkcQlllF70lA3mvLlKPm
1nqDjWKeAqzYsnnf1Mdd78Pe99pIEP5LdtW6BuoaCg7DhLHmSzhZbxtZshOAsS/b
06kq6xBnP/jMRMJyFfKWn6T4znW89FQfTEAe/AzMBi5qrvHNuWmbb2LSF8fKp1YU
fwI3uwlSaTdFT7lLo0WTaCxHmn1xgUTFTECeGyf+s1093WTFTsmcXM2Zb7EPMyzy
vpkMBWaOFVRgMgIQbixL2mDlymQZOleEPekIZckrRj16yhau1gClR+Yi10TCwiSx
PzZlldNUJ+qu0WVG778qiQ5+YNKlUlX056dc4MQBkSIDDWM6XgNPakJU2xVCobCO
eB3TYho9ZyTXCwKWh7ZJIfqADFVyZvkSwPNFmxRcRfDF3d4rkMaR4L7pLNe8siTL
uJr4/lw9CswO0eXD4i3Cd8L1WRawcHAq4HXTnWF7YPnrc6NqWjxUAd/ndNOkG8Zu
uclVzZscQeExz8iP/HazpFkTPiwaG8BLSUaWNah6TD4AG6f6GZphYoisKa63tO6p
t5AnHkvdcVLmpGAwS2S68NC6hmLLuxKREq4OTo58RYhANyb4vxw47VTuCrwdWNZy
DYd+UG86P9++7s63VDKBQijdFFNMqnupj5xa6n9Lf1fLvXRnRjczmGCX5gOZezrk
fWsFIBKwiKcGg6EgYWyb
=Kkfh
-----END PGP SIGNATURE-----

--Sig_/c_w9TM9BXeaI+tfo4eparA4--
