Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3GYNpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:45:36 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:40347 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3GYNpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:45:34 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] video: xilinxfb: Fix compilation warning
Date: Thu, 25 Jul 2013 15:45:26 +0200
Message-Id: <b8701d73538d37495b41ef465440a6d5f3018870.1374759923.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-15536-1374759927-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-15536-1374759927-0001

regs_phys is phys_addr_t (u32 or u64).
Lets use %pa printk format specifier.

Fixes compilation warning introduced by:
video: xilinxfb: Use drvdata->regs_phys instead of physaddr
(sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- Fix commit message reported by Geert

Changes in v2:
- Use %pa instead of casting

ppc44x_defconfig
Fixes regressions in v3.11-rc2

---
 drivers/video/xilinxfb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index f3d4a69..6629b29 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -341,8 +341,8 @@ static int xilinxfb_assign(struct platform_device *pdev,

 	if (drvdata->flags & BUS_ACCESS_FLAG) {
 		/* Put a banner in the log (for DEBUG) */
-		dev_dbg(dev, "regs: phys=%x, virt=%p\n", drvdata->regs_phys,
-					drvdata->regs);
+		dev_dbg(dev, "regs: phys=%pa, virt=%p\n",
+			&drvdata->regs_phys, drvdata->regs);
 	}
 	/* Put a banner in the log (for DEBUG) */
 	dev_dbg(dev, "fb: phys=%llx, virt=%p, size=%x\n",
--
1.8.2.3


--=_mimegpg-monstr-desktop-15536-1374759927-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHxK/cACgkQykllyylKDCG6UgCgmCCmUqtQEUu5SUJ+MDQfWVTa
ZMoAnjvQS4QFdVcgANKYD0PSJx9+bnEg
=w7dv
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-15536-1374759927-0001--
