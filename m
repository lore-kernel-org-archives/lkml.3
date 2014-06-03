Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbaFCPZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:25:14 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48706 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFCPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:25:12 -0400
Date: Tue, 3 Jun 2014 16:25:08 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: richard@nod.at, akpm@linux-foundation.org,
        anil_ravindranath@pmc-sierra.com
Subject: [PATCH v2 09/11] [drivers/scsi] replace strict_strto calls
Message-ID: <20140603152508.GK28580@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 09/11] [drivers/scsi] replace strict_strto calls

Replace obsolete strict_strto with more appropriate kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 drivers/scsi/pmcraid.c    | 4 ++--
 drivers/scsi/scsi_sysfs.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index be8ce54..3762488 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4213,9 +4213,9 @@ static ssize_t pmcraid_store_log_level(
 {
 	struct Scsi_Host *shost;
 	struct pmcraid_instance *pinstance;
-	unsigned long val;
+	u8 val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtou8(buf, 10, &val))
 		return -EINVAL;
 	/* log-level should be from 0 to 2 */
 	if (val > 2)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 074e8cc..80f715d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -885,9 +885,9 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 				const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	unsigned long period;
+	unsigned int period;
 
-	if (strict_strtoul(buf, 10, &period))
+	if (kstrtouint(buf, 10, &period))
 		return -EINVAL;
 
 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
-- 
1.9.3

