Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab3DDES5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:18:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56578 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3DDES4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:18:56 -0400
Date: Thu, 4 Apr 2013 15:18:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry@gilfi.de>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the usb-gadget tree with the usb tree
Message-Id: <20130404151845.406517e19f29380ccb90ac35@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_15_18_45_+1100_XVBF8hBQEkFNVApt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_15_18_45_+1100_XVBF8hBQEkFNVApt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/host/ehci-tegra.c between commit 369a9a9d2af7 ("usb: host:
ehci-tegra: Fix oops in error cleanup") from the usb tree and commit
4261b8f3538c ("usb: host: ehci-tegra: fix PHY error handling") from the
usb-gadget tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/ehci-tegra.c
index 4f3cfb8,1d2488c..0000000
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@@ -770,19 -765,15 +770,17 @@@ static int tegra_ehci_probe(struct plat
  	if (!irq) {
  		dev_err(&pdev->dev, "Failed to get IRQ\n");
  		err =3D -ENODEV;
 -		goto fail;
 +		goto fail_phy;
  	}
 =20
  	if (pdata->operating_mode =3D=3D TEGRA_USB_OTG) {
  		tegra->transceiver =3D
  			devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
- 		if (!IS_ERR_OR_NULL(tegra->transceiver))
+ 		if (!IS_ERR(tegra->transceiver))
  			otg_set_host(tegra->transceiver->otg, &hcd->self);
 +	} else {
 +		tegra->transceiver =3D ERR_PTR(-ENODEV);
  	}
- #endif
 =20
  	err =3D usb_add_hcd(hcd, irq, IRQF_SHARED);
  	if (err) {
@@@ -801,11 -792,8 +799,9 @@@
  	return err;
 =20
  fail:
- #ifdef CONFIG_USB_OTG_UTILS
- 	if (!IS_ERR_OR_NULL(tegra->transceiver))
+ 	if (!IS_ERR(tegra->transceiver))
  		otg_set_host(tegra->transceiver->otg, NULL);
- #endif
 +fail_phy:
  	usb_phy_shutdown(hcd->phy);
  fail_io:
  	clk_disable_unprepare(tegra->clk);

--Signature=_Thu__4_Apr_2013_15_18_45_+1100_XVBF8hBQEkFNVApt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXP8lAAoJEECxmPOUX5FExtwP/2nEPhlhqwQ791y9zGq8fMZy
WKf0pzPuEjEUEk2HvwrfSYC3sn8lyD6TZPJ35VD7E5jMj8WCeDeErR7rnJWQ6rgH
LFRF480UQBZXYwmtmH1GbCr2hkA/soleZ4NRsbfBPkbC0HJQvF5Eob4MxIQJNP+e
Hpy4r3wc5X0ltDpf1mUw6z7wnl+SZ7JxfOrqvXoJsjFc5Yk64f8AyOHEYk9pbzDn
gpWt8Hml4Eq8oNpoy7vG02pD2Ll8yvMJwThQVQufNO1sVUKddqPKqThWuMZFB1RT
7FhMJ33vy74OvuBDinNXmkked8EQ5Z3+rAem8B2fN04UZ/lvXTtzWsyfr9AiM1s3
FbRyi4F7CmwOwi2sjU9xRHybtNn/zVSbZ/NlDOj6u6x07woea8TpAjpMv9U8bjZq
+s4zfsRMr8XAktiYXdJqh0aHFm8dxG6gAFzWgGg+Ct1rfn1ZHy2mlWWpamBc6lTZ
kDgjcBEatTk/2HYdFd1cec9QZeBcziiyxaEzRVKdjJEv0Fdb2KMziQ0M2qXM+PCe
OeoPRQeofVIzFK58m0JZCEdHrqY1FsNJfDp4MtBRMlcHH+jHq+fKycYhXEBeTYYR
RgkY0ramdMhtyisIrYviOTK4xvNxku6KSHO/9ikoEoLoOUKAsCHS6LGAeAl3va39
PIrCic2lj795BoGxQ83b
=iy1S
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_15_18_45_+1100_XVBF8hBQEkFNVApt--
