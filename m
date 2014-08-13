Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaHML45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:56:57 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60624 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaHML44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:56:56 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH 1/2] i2c: cadence: Remove .owner field for driver
Date: Wed, 13 Aug 2014 13:56:51 +0200
Message-Id: <c076984af7e65c433fdfd3a3b0f8d20da2c18013.1407931005.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-19932-1407931012-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-19932-1407931012-0001

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/i2c/busses/i2c-cadence.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 63f3f03ecc9b..04d0a7e449ef 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -890,7 +890,6 @@ MODULE_DEVICE_TABLE(of, cdns_i2c_of_match);
 static struct platform_driver cdns_i2c_drv = {
 	.driver = {
 		.name  = DRIVER_NAME,
-		.owner = THIS_MODULE,
 		.of_match_table = cdns_i2c_of_match,
 		.pm = &cdns_i2c_dev_pm_ops,
 	},
--
1.8.2.3


--=_mimegpg-monstr-desktop-19932-1407931012-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPrUoQACgkQykllyylKDCH4WgCffYU/i71NVwj5bLRMwKTeu9VN
2KkAnA6/mOpjX0ks8U1P2vSUD+quPV4j
=YrGZ
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-19932-1407931012-0001--
