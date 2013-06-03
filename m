Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3FCKNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:13:35 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:43013 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3FCKNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:13:30 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v4 1/7] video: xilinxfb: Fix OF probing on little-endian systems
Date: Mon,  3 Jun 2013 12:13:16 +0200
Message-Id: <262ff72a86eda8d0dfadd11783340a77d04e9b67.1370254386.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370254386.git.michal.simek@xilinx.com>
References: <cover.1370254386.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370254386.git.michal.simek@xilinx.com>
References: <cover.1370254386.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9731-1370254405-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9731-1370254405-0001

From: Michal Simek <monstr@monstr.eu>

DTB is always big-endian that's why it is necessary
to properly convert value (*p).
It is automatically done in of_property_read_u32().

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v4: None
Changes in v3:
- fix commit message

Changes in v2:
- use of_property_read_u32 helper function

 drivers/video/xilinxfb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index af0b4fd..aecd15d 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -406,8 +406,7 @@ static int xilinxfb_release(struct device *dev)
 static int xilinxfb_of_probe(struct platform_device *op)
 {
 	const u32 *prop;
-	u32 *p;
-	u32 tft_access;
+	u32 tft_access = 0;
 	struct xilinxfb_platform_data pdata;
 	struct resource res;
 	int size, rc;
@@ -427,8 +426,8 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	 * To check whether the core is connected directly to DCR or PLB
 	 * interface and initialize the tft_access accordingly.
 	 */
-	p = (u32 *)of_get_property(op->dev.of_node, "xlnx,dcr-splb-slave-if", NULL);
-	tft_access = p ? *p : 0;
+	of_property_read_u32(op->dev.of_node, "xlnx,dcr-splb-slave-if",
+			     &tft_access);

 	/*
 	 * Fill the resource structure if its direct PLB interface
--
1.8.2.3


--=_mimegpg-monstr-desktop-9731-1370254405-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsbEUACgkQykllyylKDCHLmACdFjOdPjdUrJxttWT4VSVTxXfY
VbgAn3GJ0HcuvqmK+/YPTofEdRq1slKq
=HOLi
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9731-1370254405-0001--
