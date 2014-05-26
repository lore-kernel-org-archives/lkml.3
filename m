Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaEZWPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:15:04 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40675 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaEZWO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:14:59 -0400
Date: Mon, 26 May 2014 23:14:54 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: anvil_ravindranath@pmc-sierra.com, richard@nod.at
Subject: [PATCH 10/12] [drivers/scsi] Remove obsolete strict_strto calls
Message-ID: <20140526221454.GL25779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH 10/12] [drivers/scsi] replace strict_strto calls

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

