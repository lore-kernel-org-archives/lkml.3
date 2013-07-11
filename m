Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab3GKO0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab3GKO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sreekanth Reddy <sreekanth.reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 56/98] [SCSI] mpt2sas: Fix for max_sectors warning message is stating the incorrect range
Date: Thu, 11 Jul 2013 15:24:26 +0100
Message-Id: <1373552708-15235-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "sreekanth.reddy@lsi.com" <sreekanth.reddy@lsi.com>

commit eece5de59c090cf6cc04622a0abedb1553383cdc upstream.

When specifying the command line option "max_sectors" less than 64, then
warning message should provide correct upper boundary value 32767 instead of
8192.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index d672b64..e6d2e69 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8061,8 +8061,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (max_sectors != 0xFFFF) {
 		if (max_sectors < 64) {
 			shost->max_sectors = 64;
-			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "
-			    "for max_sectors, range is 64 to 8192. Assigning "
+			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "\
+			    "for max_sectors, range is 64 to 32767. Assigning "\
 			    "value of 64.\n", ioc->name, max_sectors);
 		} else if (max_sectors > 32767) {
 			shost->max_sectors = 32767;
-- 
1.8.1.2

