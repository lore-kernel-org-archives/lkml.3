Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3EaM6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:58:21 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:46736 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3EaM4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:56:03 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v3 4/8] video: xilinxfb: Use drvdata->regs_phys instead of physaddr
Date: Fri, 31 May 2013 14:55:34 +0200
Message-Id: <ef73f4a9d2f95a19819e1e37c0f3377033779cd6.1370004925.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8141-1370004958-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8141-1370004958-0001

physaddr will be remove in the next patch.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- New patch in this patchset based on discussions

Changes in v2: None

 drivers/video/xilinxfb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index d94c992..1b55f18 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -325,7 +325,7 @@ static int xilinxfb_assign(struct device *dev,

 	if (drvdata->flags & BUS_ACCESS_FLAG) {
 		/* Put a banner in the log (for DEBUG) */
-		dev_dbg(dev, "regs: phys=%lx, virt=%p\n", physaddr,
+		dev_dbg(dev, "regs: phys=%x, virt=%p\n", drvdata->regs_phys,
 					drvdata->regs);
 	}
 	/* Put a banner in the log (for DEBUG) */
@@ -353,7 +353,7 @@ err_fbmem:

 err_map:
 	if (drvdata->flags & BUS_ACCESS_FLAG)
-		release_mem_region(physaddr, 8);
+		release_mem_region(drvdata->regs_phys, 8);

 err_region:
 	kfree(drvdata);
--
1.8.2.3


--=_mimegpg-monstr-desktop-8141-1370004958-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGond4ACgkQykllyylKDCE2MwCfRF9/Bav3CqONvZ/8bTYb+Ktj
pGUAoII9nudByTfMZc13zPVxEtrXxDR0
=E5bI
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8141-1370004958-0001--
