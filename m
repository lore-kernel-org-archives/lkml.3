Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaHMLvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:51:37 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43652 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaHMLvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:51:35 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] watchdog: xilinx: Remove .owner field for driver
Date: Wed, 13 Aug 2014 13:51:28 +0200
Message-Id: <e8e4f914035bfd055525e224da9d3e62e70edb1b.1407930684.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17974-1407930688-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17974-1407930688-0001

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/watchdog/of_xilinx_wdt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 1e6e28df5d7b..b2e1b4cbbdc1 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -236,7 +236,6 @@ static struct platform_driver xwdt_driver = {
 	.probe       = xwdt_probe,
 	.remove      = xwdt_remove,
 	.driver = {
-		.owner = THIS_MODULE,
 		.name  = WATCHDOG_NAME,
 		.of_match_table = xwdt_of_match,
 	},
--
1.8.2.3


--=_mimegpg-monstr-desktop-17974-1407930688-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPrUUAACgkQykllyylKDCH1fgCeNP2mOB2kT+bXTac4FqTlQG99
F00AnjSBIxTZrQDNjIeViBdBlnPCgsWJ
=mpMi
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17974-1407930688-0001--
