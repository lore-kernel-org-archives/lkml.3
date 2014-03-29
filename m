Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaC2SZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:25:40 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63987 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaC2SZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:25:38 -0400
Date: Sat, 29 Mar 2014 23:56:03 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: xjtuwjp@gmail.com, lindar_liu@usish.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 37/55] scsi: Mark function as static in pm8001/pm80xx_hwi.c
Message-ID: <818bb6b9d6be43bf4a6671bb6d27514d5864fbe3.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in pm8001/pm80xx_hwi.c because they are not
used outside this file.

This eliminates the following warning in pm8001/pm80xx_hwi.c:
drivers/scsi/pm8001/pm80xx_hwi.c:69:6: warning: no previous prototype for ‘pm80xx_pci_mem_copy’ [-Wmissing-prototypes]
drivers/scsi/pm8001/pm80xx_hwi.c:4529:6: warning: no previous prototype for ‘mpi_set_phy_profile_req’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c950dc5..156947e 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -66,7 +66,7 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
 	return 0;
 }
 
-void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
+static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
 				const void *destination,
 				u32 dw_count, u32 bus_base_number)
 {
@@ -4526,8 +4526,8 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	return IRQ_HANDLED;
 }
 
-void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
-	u32 operation, u32 phyid, u32 length, u32 *buf)
+static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
+				u32 operation, u32 phyid, u32 length, u32 *buf)
 {
 	u32 tag , i, j = 0;
 	int rc;
-- 
1.7.9.5

