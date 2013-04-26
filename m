Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab3DZHMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:12:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36233 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab3DZHMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:12:32 -0400
Date: Fri, 26 Apr 2013 17:12:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bastian Hecht <hechtb@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: linux-next: manual merge of the renesas tree with the input tree
Message-Id: <20130426171229.134dc25101970f908132d523@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_17_12_29_+1000_a+aKUwX1k7PK_bgm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_17_12_29_+1000_a+aKUwX1k7PK_bgm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/mach-shmobile/board-armadillo800eva.c between commit
cbaf7f808081 ("ARM - shmobile: Armadillo800EVA: Move st1232 reset pin
handling") from the input tree and commit 0c5ba87e1b2e ("ARM: shmobile:
armadillo800eva: Register pinctrl mapping for INTC") from the renesas
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/board-armadillo800eva.c
index b85b288,ff04d1e..0000000
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@@ -1127,32 -1151,10 +1161,7 @@@ static void __init eva_init(void
  	gpio_request_one(61, GPIOF_OUT_INIT_HIGH, NULL); /* LCDDON */
  	gpio_request_one(202, GPIOF_OUT_INIT_LOW, NULL); /* LCD0_LED_CONT */
 =20
--	/* Touchscreen */
- 	gpio_request(GPIO_FN_IRQ10,	NULL); /* TP_INT */
-=20
 -	gpio_request_one(166, GPIOF_OUT_INIT_HIGH, NULL); /* TP_RST_B */
 -
  	/* GETHER */
- 	gpio_request(GPIO_FN_ET_CRS,		NULL);
- 	gpio_request(GPIO_FN_ET_MDC,		NULL);
- 	gpio_request(GPIO_FN_ET_MDIO,		NULL);
- 	gpio_request(GPIO_FN_ET_TX_ER,		NULL);
- 	gpio_request(GPIO_FN_ET_RX_ER,		NULL);
- 	gpio_request(GPIO_FN_ET_ERXD0,		NULL);
- 	gpio_request(GPIO_FN_ET_ERXD1,		NULL);
- 	gpio_request(GPIO_FN_ET_ERXD2,		NULL);
- 	gpio_request(GPIO_FN_ET_ERXD3,		NULL);
- 	gpio_request(GPIO_FN_ET_TX_CLK,		NULL);
- 	gpio_request(GPIO_FN_ET_TX_EN,		NULL);
- 	gpio_request(GPIO_FN_ET_ETXD0,		NULL);
- 	gpio_request(GPIO_FN_ET_ETXD1,		NULL);
- 	gpio_request(GPIO_FN_ET_ETXD2,		NULL);
- 	gpio_request(GPIO_FN_ET_ETXD3,		NULL);
- 	gpio_request(GPIO_FN_ET_PHY_INT,	NULL);
- 	gpio_request(GPIO_FN_ET_COL,		NULL);
- 	gpio_request(GPIO_FN_ET_RX_DV,		NULL);
- 	gpio_request(GPIO_FN_ET_RX_CLK,		NULL);
-=20
  	gpio_request_one(18, GPIOF_OUT_INIT_HIGH, NULL); /* PHY_RST */
 =20
  	/* USB */

--Signature=_Fri__26_Apr_2013_17_12_29_+1000_a+aKUwX1k7PK_bgm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJReijdAAoJEECxmPOUX5FEGfIP/0Y2uH7UKMh12yDSCaKdE7hN
LEgKJljdJPhYV+j7VNaKQrCOxYB0OiGuxDE1AMZBoXAo57vwCmjlJjPW0/0FEr/S
2agkgNbyINGDFz8Ae1UTZW0r9CWSR0aZpMFtDgpt/DaJp891ITVtskUb+nrypqQI
S3CW8xCQdAVc+wOwd78EQdYPQJMy1RPXOamSNP6cWDosze0vLv5WuIv6irS6fNMm
+o9rJFcIOTPgwrzW50/tRE+4PiDivUm1oDsPVmqel0ldFUB1ap+9S8wuhp0/Fh5w
2M9itJKn6wbBme9LuJHjcAFJDXd1mtn1sx67BzXYCimXE5S+XFY0Ut2U7nKM1TLd
eshx3/Krtlm4n5Rm0IZi8grH5ws8PaXB1V74lYtvIf0jedCqk6cD0nDBAaO5aoeC
IpGyX/pTwfPKt/iPBarQq6sOabp8Oie569RmXjpiiDqGuxrypoHX/79Cd6cpmnBF
lmDATh0Haf/J9yeeMnAexVRiTv/oKdOA4f+iQiLklIy8ufeHUPQZ4tg/3AJNejsF
0htxc0LB0vveZXaRVCt2m+2+OqTJaUgIjD5vdC4KqmmXaL4/uyC5Kr8eiW0s1LJ7
8xEtFhOslP76RXrDZiL7XonfQmlXFfuMVGCVBwyYqmd3heDZlyWmDv2O8AFSBZh+
lVyTzCcnQuqV/t442ZG2
=2kSq
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_17_12_29_+1000_a+aKUwX1k7PK_bgm--
