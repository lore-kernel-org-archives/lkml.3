Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaG3U7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:59:05 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44833 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaG3U7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:59:01 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jingoo Han <jg1.han@samsung.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: csiostor: csio_init.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Wed, 30 Jul 2014 23:00:28 +0200
Message-Id: <1406754028-20210-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you use kzalloc before strncpy you must copy sizeof -1.
And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/csiostor/csio_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 1aafc33..d5ea81c 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -532,7 +532,8 @@ static struct csio_hw *csio_hw_alloc(struct pci_dev *pdev)
 		goto err;
 
 	hw->pdev = pdev;
-	strncpy(hw->drv_version, CSIO_DRV_VERSION, 32);
+	strncpy(hw->drv_version, CSIO_DRV_VERSION,
+			sizeof(hw->drv_version) - 1);
 
 	/* memory pool/DMA pool allocation */
 	if (csio_resource_alloc(hw))
-- 
1.7.10.4

