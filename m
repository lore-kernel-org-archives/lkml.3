Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3JIKww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:52:52 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33102 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3JIKw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:52:27 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v2 2/3] video: xilinxfb: Use devm_kzalloc instead of kzalloc
Date: Wed,  9 Oct 2013 12:52:13 +0200
Message-Id: <748c16093663172918a90a53dc472cb8beb584ca.1381315928.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381315928.git.michal.simek@xilinx.com>
References: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381315928.git.michal.simek@xilinx.com>
In-Reply-To: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381315928.git.michal.simek@xilinx.com>
References: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381315928.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-29043-1381315944-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-29043-1381315944-0001

Simplify driver probe and release function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
---
Changes in v2:
Rebased on git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git for-next

 drivers/video/xilinxfb.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index d12345f..98c7a6f 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -368,8 +368,6 @@ err_fbmem:
 		devm_iounmap(dev, drvdata->regs);

 err_region:
-	kfree(drvdata);
-
 	return rc;
 }

@@ -402,8 +400,6 @@ static int xilinxfb_release(struct device *dev)
 		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
 #endif

-	kfree(drvdata);
-
 	return 0;
 }

@@ -423,7 +419,7 @@ static int xilinxfb_of_probe(struct platform_device *pdev)
 	pdata = xilinx_fb_default_pdata;

 	/* Allocate the driver data region */
-	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata) {
 		dev_err(&pdev->dev, "Couldn't allocate device private record\n");
 		return -ENOMEM;
@@ -451,7 +447,6 @@ static int xilinxfb_of_probe(struct platform_device *pdev)
 		drvdata->dcr_host = dcr_map(op->dev.of_node, start, drvdata->dcr_len);
 		if (!DCR_MAP_OK(drvdata->dcr_host)) {
 			dev_err(&op->dev, "invalid DCR address\n");
-			kfree(drvdata);
 			return -ENODEV;
 		}
 	}
--
1.8.2.3


--=_mimegpg-monstr-desktop-29043-1381315944-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJVNWgACgkQykllyylKDCEtOACfd1ZwEvvwl1vLmibaorqhFZE9
NGQAnjXIaJb6aVH9ciKqK8Oc57wqqCT0
=OagT
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-29043-1381315944-0001--
