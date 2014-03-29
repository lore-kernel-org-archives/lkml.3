Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaC2SXn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:23:43 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55322 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaC2SXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:23:42 -0400
Date: Sat, 29 Mar 2014 23:54:07 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: xjtuwjp@gmail.com, lindar_liu@usish.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 35/55] scsi: Mark function as static in pm8001/pm8001_sas.c
Message-ID: <0eeec2c97bdb4944256ec742ca4af14a1f0618dd.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in pm8001/pm8001_sas.c because it is not used
outside this file.

This eliminates the following warning in pm8001/pm8001_sas.c:
drivers/scsi/pm8001/pm8001_sas.c:551:23: warning: no previous prototype for ‘pm8001_alloc_dev’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/pm8001/pm8001_sas.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f50ac44..8a82a74 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -548,7 +548,8 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
   * pm8001_alloc_dev - find a empty pm8001_device
   * @pm8001_ha: our hba card information
   */
-struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info *pm8001_ha)
+static struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info
+					      *pm8001_ha)
 {
 	u32 dev;
 	for (dev = 0; dev < PM8001_MAX_DEVICES; dev++) {
-- 
1.7.9.5

