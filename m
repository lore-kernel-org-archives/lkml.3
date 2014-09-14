Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaINReA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:34:00 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:33645 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaINRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:33:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sis: sis_main.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 14 Sep 2014 19:35:48 +0200
Message-Id: <1410716148-16243-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/sis/sis_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index 3f12a2d..1f4c216 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -5830,7 +5830,7 @@ static int sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			ivideo->cardnumber++;
 	}
 
-	strncpy(ivideo->myid, chipinfo->chip_name, 30);
+	strlcpy(ivideo->myid, chipinfo->chip_name, sizeof(ivideo->myid));
 
 	ivideo->warncount = 0;
 	ivideo->chip_id = pdev->device;
-- 
1.7.10.4

