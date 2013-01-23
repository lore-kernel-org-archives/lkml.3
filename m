Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3AWEP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:15:56 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39102 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3AWEPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:15:55 -0500
Date: Wed, 23 Jan 2013 15:15:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the driver-core tree with Linus' tree
Message-Id: <20130123151552.1b8723dfa9c9a5dd75f7fec2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_15_15_52_+1100_28HuuR1g7Hc/GKWZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_15_15_52_+1100_28HuuR1g7Hc/GKWZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/gpio/gpio-mvebu.c between commit 11c0ceec073c ("gpio: mvebu:
Don't free chip label memory") from Linus' tree and commit 641d03422a59
("gpio: Convert to devm_ioremap_resource()") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-mvebu.c
index 6819d63,bf6c7c9..0000000
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@@ -544,10 -545,10 +545,9 @@@ static int mvebu_gpio_probe(struct plat
  	mvchip->chip.of_node =3D np;
 =20
  	spin_lock_init(&mvchip->lock);
- 	mvchip->membase =3D devm_request_and_ioremap(&pdev->dev, res);
- 	if (! mvchip->membase) {
- 		dev_err(&pdev->dev, "Cannot ioremap\n");
- 		return -ENOMEM;
+ 	mvchip->membase =3D devm_ioremap_resource(&pdev->dev, res);
+ 	if (IS_ERR(mvchip->membase)) {
 -		kfree(mvchip->chip.label);
+ 		return PTR_ERR(mvchip->membase);
  	}
 =20
  	/* The Armada XP has a second range of registers for the
@@@ -559,10 -560,12 +559,10 @@@
  			return -ENODEV;
  		}
 =20
- 		mvchip->percpu_membase =3D devm_request_and_ioremap(&pdev->dev, res);
- 		if (! mvchip->percpu_membase) {
- 			dev_err(&pdev->dev, "Cannot ioremap\n");
- 			return -ENOMEM;
+ 		mvchip->percpu_membase =3D devm_ioremap_resource(&pdev->dev,
+ 							       res);
+ 		if (IS_ERR(mvchip->percpu_membase)) {
 -			kfree(mvchip->chip.label);
+ 			return PTR_ERR(mvchip->percpu_membase);
  		}
  	}
 =20

--Signature=_Wed__23_Jan_2013_15_15_52_+1100_28HuuR1g7Hc/GKWZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/2P4AAoJEECxmPOUX5FEpIkP/245zgqFt34eIlzD/9E4ue7Q
ilsWbs3JxdygT9egHfx3D4m8wyq7ZJe2M8RBtpCMRBYLkjgsnH6kSGgTgZ+6kNQB
4Tmq4DXtlUAiELUKwC6iOkiqzUsQ+cTaxhHj3ILjql7fU9uB92EHMzjae33QToF5
ivSCVkO8cFmpo45CHqIvl1pgL2uVhADZZrx7NgZpFS4mNq0PPJ7M53FCQwP7cIK2
MlXajFLigAF5GuMQyqJqtMZshvL8jORO22IAlfMEUIAdwNPbr7B2nSqUoWZy+RnY
7PppPA0nAoLBBhXFriJW+MJ3ECUl929SZ3T78mHPOWVrNoDF24fuN+Z+Z0W4+9tS
+2fibSgF1OrBckIE2471jtKF3PSHz7/1+TewQx6/xgKulxx9v0oI8YyKI/OAhAli
aNO9FkAu7j2iRClR/CePOX14qVCx9vP9bMt1REtTgzwfSrW/sDOJ/m5tDmsIr+M9
d0YTTgQCwCsZIMGBPDrHS4Nxwop6xzfd9Mu3cidIzIDBvLYlgUNWF0sFMLxvOIYQ
NXuuNnBhTRMv51u0XwgIHnDxe3TKhh5llY0nzJSffKkB0Eax9WMspV0GYl7xbhVo
EjCe7iQaHhAz+KSMsRYKsn1bubl6unsbpciSfg7Ox3afwKZM8377ehakv84LzMxQ
4WyuHl5wc+x1c5swJlr9
=Mw17
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_15_15_52_+1100_28HuuR1g7Hc/GKWZ--
