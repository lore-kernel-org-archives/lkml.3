Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab3FCMb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:31:57 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:54753 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab3FCMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:31:54 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 1/6] GPIO: xilinx: Simplify driver probe function
Date: Mon,  3 Jun 2013 14:31:16 +0200
Message-Id: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25543-1370262681-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25543-1370262681-0001

Simplification is done by using OF helper function
which increase readability of code and remove
(if (var) var = be32_to_cpup;) assignment.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
- New patch in this series

 drivers/gpio/gpio-xilinx.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 9ae7aa8..2aad534 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -170,24 +170,20 @@ static int xgpio_of_probe(struct device_node *np)
 		return -ENOMEM;

 	/* Update GPIO state shadow register with default value */
-	tree_info = of_get_property(np, "xlnx,dout-default", NULL);
-	if (tree_info)
-		chip->gpio_state = be32_to_cpup(tree_info);
+	of_property_read_u32(np, "xlnx,dout-default", &chip->gpio_state);
+
+	/* By default, all pins are inputs */
+	chip->gpio_dir = 0xFFFFFFFF;

 	/* Update GPIO direction shadow register with default value */
-	chip->gpio_dir = 0xFFFFFFFF; /* By default, all pins are inputs */
-	tree_info = of_get_property(np, "xlnx,tri-default", NULL);
-	if (tree_info)
-		chip->gpio_dir = be32_to_cpup(tree_info);
+	of_property_read_u32(np, "xlnx,tri-default", &chip->gpio_dir);
+
+	/* By default assume full GPIO controller */
+	chip->mmchip.gc.ngpio = 32;

 	/* Check device node and parent device node for device width */
-	chip->mmchip.gc.ngpio = 32; /* By default assume full GPIO controller */
-	tree_info = of_get_property(np, "xlnx,gpio-width", NULL);
-	if (!tree_info)
-		tree_info = of_get_property(np->parent,
-					    "xlnx,gpio-width", NULL);
-	if (tree_info)
-		chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);
+	of_property_read_u32(np, "xlnx,gpio-width",
+			      (u32 *)&chip->mmchip.gc.ngpio);

 	spin_lock_init(&chip->gpio_lock);

--
1.8.2.3


--=_mimegpg-monstr-desktop-25543-1370262681-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsjJkACgkQykllyylKDCGAcACfcHTyia+GbGWMpF93jKVnyxv5
zGkAniSbB3YAr9l5LUXFFBCOeIKeA850
=jBN4
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25543-1370262681-0001--
