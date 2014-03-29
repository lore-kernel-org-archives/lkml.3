Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaC2STE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:19:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44160 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaC2STC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:19:02 -0400
Date: Sat, 29 Mar 2014 23:49:26 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 31/55] scsi: Mark functions as static in mvsas/mv_sas.c
Message-ID: <36003591ecb5adf76db0306aa63b2f6b2d208e43.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in mvsas/mv_sas.c because they are not used
outside this file.

This eliminates the following warnings in mvsas/mv_sas.c:
drivers/scsi/mvsas/mv_sas.c:77:18: warning: no previous prototype for ‘mvs_find_dev_mvi’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:105:5: warning: no previous prototype for ‘mvs_find_dev_phyno’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1260:20: warning: no previous prototype for ‘mvs_alloc_dev’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1277:6: warning: no previous prototype for ‘mvs_free_dev’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1287:5: warning: no previous prototype for ‘mvs_dev_found_notify’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1343:6: warning: no previous prototype for ‘mvs_dev_gone_notify’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1709:6: warning: no previous prototype for ‘mvs_set_sense’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_sas.c:1748:6: warning: no previous prototype for ‘mvs_fill_ssp_resp_iu’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/mvsas/mv_sas.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6c1f223..80c2b1d 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -74,7 +74,7 @@ void mvs_tag_init(struct mvs_info *mvi)
 		mvs_tag_clear(mvi, i);
 }
 
-struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
+static struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 {
 	unsigned long i = 0, j = 0, hi = 0;
 	struct sas_ha_struct *sha = dev->port->ha;
@@ -102,7 +102,7 @@ struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 
 }
 
-int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
+static int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
 {
 	unsigned long i = 0, j = 0, n = 0, num = 0;
 	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
@@ -1257,7 +1257,7 @@ void mvs_port_deformed(struct asd_sas_phy *sas_phy)
 	mvs_port_notify_deformed(sas_phy, 1);
 }
 
-struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
+static struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
 {
 	u32 dev;
 	for (dev = 0; dev < MVS_MAX_DEVICES; dev++) {
@@ -1274,7 +1274,7 @@ struct mvs_device *mvs_alloc_dev(struct mvs_info *mvi)
 	return NULL;
 }
 
-void mvs_free_dev(struct mvs_device *mvi_dev)
+static void mvs_free_dev(struct mvs_device *mvi_dev)
 {
 	u32 id = mvi_dev->device_id;
 	memset(mvi_dev, 0, sizeof(*mvi_dev));
@@ -1284,7 +1284,7 @@ void mvs_free_dev(struct mvs_device *mvi_dev)
 	mvi_dev->taskfileset = MVS_ID_NOT_MAPPED;
 }
 
-int mvs_dev_found_notify(struct domain_device *dev, int lock)
+static int mvs_dev_found_notify(struct domain_device *dev, int lock)
 {
 	unsigned long flags = 0;
 	int res = 0;
@@ -1340,7 +1340,7 @@ int mvs_dev_found(struct domain_device *dev)
 	return mvs_dev_found_notify(dev, 1);
 }
 
-void mvs_dev_gone_notify(struct domain_device *dev)
+static void mvs_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags = 0;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
@@ -1706,7 +1706,7 @@ static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
 	return stat;
 }
 
-void mvs_set_sense(u8 *buffer, int len, int d_sense,
+static void mvs_set_sense(u8 *buffer, int len, int d_sense,
 		int key, int asc, int ascq)
 {
 	memset(buffer, 0, len);
@@ -1745,8 +1745,8 @@ void mvs_set_sense(u8 *buffer, int len, int d_sense,
 	return;
 }
 
-void mvs_fill_ssp_resp_iu(struct ssp_response_iu *iu,
-				u8 key, u8 asc, u8 asc_q)
+static void mvs_fill_ssp_resp_iu(struct ssp_response_iu *iu,
+				 u8 key, u8 asc, u8 asc_q)
 {
 	iu->datapres = 2;
 	iu->response_data_len = 0;
-- 
1.7.9.5

