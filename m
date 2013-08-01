Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3HAFc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:32:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51324 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3HAFc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:32:58 -0400
Date: Thu, 1 Aug 2013 15:32:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: linux-next: manual merge of the usb-gadget tree with Linus' tree
Message-Id: <20130801153250.fe6d2739056980efb2362704@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Aug_2013_15_32_50_+1000_wiKG+AP.lTNAVR_I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Aug_2013_15_32_50_+1000_wiKG+AP.lTNAVR_I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got conflicts in
drivers/usb/musb/omap2430.c and drivers/usb/musb/tusb6010.c between
commit c1f01be4060b ("usb: musb: fix resource passed from glue layer to
musb") from Linus' tree and commit c1a7d67c1901 ("usb: musb: use
dev_get_platdata()") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/musb/omap2430.c
index f44e8b5,ebb46ec..0000000
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@@ -481,8 -481,8 +481,8 @@@ static u64 omap2430_dmamask =3D DMA_BIT_M
 =20
  static int omap2430_probe(struct platform_device *pdev)
  {
 -	struct resource			musb_resources[2];
 +	struct resource			musb_resources[3];
- 	struct musb_hdrc_platform_data	*pdata =3D pdev->dev.platform_data;
+ 	struct musb_hdrc_platform_data	*pdata =3D dev_get_platdata(&pdev->dev);
  	struct omap_musb_board_data	*data;
  	struct platform_device		*musb;
  	struct omap2430_glue		*glue;
diff --cc drivers/usb/musb/tusb6010.c
index 6f8a9ca,2196ee6..0000000
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@@ -1156,8 -1156,8 +1156,8 @@@ static u64 tusb_dmamask =3D DMA_BIT_MASK(
 =20
  static int tusb_probe(struct platform_device *pdev)
  {
 -	struct resource musb_resources[2];
 +	struct resource musb_resources[3];
- 	struct musb_hdrc_platform_data	*pdata =3D pdev->dev.platform_data;
+ 	struct musb_hdrc_platform_data	*pdata =3D dev_get_platdata(&pdev->dev);
  	struct platform_device		*musb;
  	struct tusb6010_glue		*glue;
 =20

--Signature=_Thu__1_Aug_2013_15_32_50_+1000_wiKG+AP.lTNAVR_I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR+fMGAAoJEECxmPOUX5FEIx8P/3MxV9ur/+ZYN/7zdK2R9UTm
7zvrdBp1vEUpfBR8RCDb1JWMYkgH+6iLMNs5JNQokvAilNSLxNjWqFIBs4hoOg1W
AgNsmvgXoOJSO7SbS81QkqsF8c0N7KWFehPIKi3L4POP0hdiEaV6aiWGAFLfC3lH
Nguliv4Xz4ffj5sjvq0drvctPfd4N06rNWwnPwT6vUkpHa1LK6cpW8xSipNN0DVR
3NTsfGrL6KLYUvL+QOmqkKMlb4ZI7ITb73Y7UZKl07cvT+zF57KmTGWfTF4NHufm
vZey4mvlKjKtIlYJRTmNKGhoezYCa0jyJ2L57UHCOhFQQQhrqxhG63cjBHzX9gpI
4mv3WG/TPZ32zjAgjWZmVyITvKZ+Sph2M48wYd3m1APTp8mdZHldPRno/+8YNWMJ
4TtvBBMsfv6yRQUdRCp1RfxZWNC1SNvsMETxvgzjffBCBsjeIHUdrVvBLqsYkpP+
yu2zA/Gbyyj5BxZzc1nAkwZIuV11NmJaTjJT5dwlp/HhcDc5x+osXS4+IGwWTZ8w
Rxd104kt12VJV0Xwbn/M74GYGZR9MFr+YeqT18CbT3DHaqc6/wme1Yj5t6SWgktm
nEC57doouUITPjUWBzUhccQOH64SKUQD33957pVEwWn0Lp2TsZs6LRspO9/ia85T
Kr2L0ABCgkrXc2fLdMCo
=Qx35
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Aug_2013_15_32_50_+1000_wiKG+AP.lTNAVR_I--
