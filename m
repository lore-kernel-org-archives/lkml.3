Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968091Ab3E3JlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:41:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38190 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968060Ab3E3JlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:41:10 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 1/3] video: xilinxfb: Fix OF probing on little-endian systems
Date: Thu, 30 May 2013 11:41:00 +0200
Message-Id: <27e53d5633766ab0dc1ac492023d5a0d0199e3aa.1369906849.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-15062-1369906862-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-15062-1369906862-0001

From: Michal Simek <monstr@monstr.eu>

DTB is always big-endian that's why is necessary
to convert it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
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


--=_mimegpg-monstr-desktop-15062-1369906862-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGnHq4ACgkQykllyylKDCHicQCfa321WW8tMg8wbS2w8IIhGCM8
jm4An3UPkCJTRPQjf42rvMccZNuBsrFl
=eLYO
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-15062-1369906862-0001--
