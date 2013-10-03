Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3JCJqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:46:47 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:47920 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3JCJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:46:46 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 1/9] dma: pl330: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:23 +0200
Message-Id: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4059-1380793592-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4059-1380793592-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/dma/pl330.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index a562d24..dfb2931 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -3029,8 +3029,6 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)

 	return 0;
 probe_err3:
-	amba_set_drvdata(adev, NULL);
-
 	/* Idle the DMAC */
 	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
 			chan.device_node) {
@@ -3064,7 +3062,6 @@ static int pl330_remove(struct amba_device *adev)
 		of_dma_controller_free(adev->dev.of_node);

 	dma_async_device_unregister(&pdmac->ddma);
-	amba_set_drvdata(adev, NULL);

 	/* Idle the DMAC */
 	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
--
1.8.2.3


--=_mimegpg-monstr-desktop-4059-1380793592-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPPgACgkQykllyylKDCGuKgCfVGwW0iqiOyGtHI6DqOFbtoFa
issAn0LgI7iJf4lC7cNtyIASo7gypTn8
=+/Ro
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4059-1380793592-0001--
