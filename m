Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaHML74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:59:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40437 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaHML7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:59:53 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Jens Axboe <axboe@fb.com>
Subject: [PATCH] block: systemace: Remove .owner field for driver
Date: Wed, 13 Aug 2014 13:59:50 +0200
Message-Id: <0002a277537c569a56559cf4277fb4cd56687969.1407931183.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-20664-1407931190-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-20664-1407931190-0001

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/block/xsysace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index ab3ea62e5dfc..c4328d9d9981 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1203,7 +1203,6 @@ static struct platform_driver ace_platform_driver = {
 	.probe = ace_probe,
 	.remove = ace_remove,
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "xsysace",
 		.of_match_table = ace_of_match,
 	},
--
1.8.2.3


--=_mimegpg-monstr-desktop-20664-1407931190-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPrUzYACgkQykllyylKDCG9RwCfa2mJOz2r2qVR6fCplnS9I0Dr
WLQAoIeB4kmz9Gt4vUPl3yBGRFrwqrx9
=6wcx
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-20664-1407931190-0001--
