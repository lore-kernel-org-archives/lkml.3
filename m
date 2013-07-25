Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3GYLWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:22:06 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63394 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3GYLWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:22:02 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] video: xilinxfb: Fix compilation warning
Date: Thu, 25 Jul 2013 13:21:54 +0200
Message-Id: <204d93f8a9dffef6ff00d961f91be0b465f21841.1374751310.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-10653-1374751314-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-10653-1374751314-0001

regs_phys is phys_addr_t (u32 or u64).
Lets retype it to u64.

Fixes compilation warning introduced by:
video: xilinxfb: Use drvdata->regs_phys instead of physaddr
(sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
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


--=_mimegpg-monstr-desktop-10653-1374751314-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHxClIACgkQykllyylKDCGvRQCeLyz0P8oGAxPmDZ08Dz4gnx00
QfYAnj+0pOvklgckpxiDl0fxDoM6nsiB
=DWWc
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-10653-1374751314-0001--
