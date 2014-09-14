Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaINP6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:58:14 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:41224 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaINP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:58:12 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] block: cciss.c:  Cleaning up unnecessary use of memset in conjunction with strncpy
Date: Sun, 14 Sep 2014 18:00:01 +0200
Message-Id: <1410710401-14241-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using memset before strncpy just to ensure a trailing null
character is an unnecessary double writing of a string

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ff20f19..f892618 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4580,8 +4580,8 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 
 static void init_driver_version(char *driver_version, int len)
 {
-	memset(driver_version, 0, len);
 	strncpy(driver_version, "cciss " DRIVER_NAME, len - 1);
+	driver_version[len - 1] = '\0';
 }
 
 static int write_driver_ver_to_cfgtable(CfgTable_struct __iomem *cfgtable)
-- 
1.7.10.4

