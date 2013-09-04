Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005Ab3IDOkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:40:35 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36228 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762790Ab3IDOk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:40:29 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: [PATCH] dma: pl330: Simplify irq allocation
Date: Wed,  4 Sep 2013 16:40:17 +0200
Message-Id: <7a8e72582d8f4262a70bb9b7050fb6cb3be15578.1378305608.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23948-1378305617-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23948-1378305617-0001

Use devm_request_irq function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/dma/pl330.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index fa645d8..1989e4c 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2930,7 +2930,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	amba_set_drvdata(adev, pdmac);

 	irq = adev->irq[0];
-	ret = request_irq(irq, pl330_irq_handler, 0,
+	ret = devm_request_irq(&adev->dev, irq, pl330_irq_handler, 0,
 			dev_name(&adev->dev), pi);
 	if (ret)
 		return ret;
@@ -2938,7 +2938,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pi->pcfg.periph_id = adev->periphid;
 	ret = pl330_add(pi);
 	if (ret)
-		goto probe_err1;
+		return ret;

 	INIT_LIST_HEAD(&pdmac->desc_pool);
 	spin_lock_init(&pdmac->pool_lock);
@@ -3041,8 +3041,6 @@ probe_err3:
 	}
 probe_err2:
 	pl330_del(pi);
-probe_err1:
-	free_irq(irq, pi);

 	return ret;
 }
@@ -3052,7 +3050,6 @@ static int pl330_remove(struct amba_device *adev)
 	struct dma_pl330_dmac *pdmac = amba_get_drvdata(adev);
 	struct dma_pl330_chan *pch, *_p;
 	struct pl330_info *pi;
-	int irq;

 	if (!pdmac)
 		return 0;
@@ -3079,9 +3076,6 @@ static int pl330_remove(struct amba_device *adev)

 	pl330_del(pi);

-	irq = adev->irq[0];
-	free_irq(irq, pi);
-
 	return 0;
 }

--
1.8.2.3


--=_mimegpg-monstr-desktop-23948-1378305617-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlInRlEACgkQykllyylKDCHYewCfYHH/s2iY4Mty/Y0ORHCEa+w9
yF8Anits++q4/E5ANp2oU9rRtrCNCm8L
=kB8m
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23948-1378305617-0001--
