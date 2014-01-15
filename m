Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaAOWBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:01:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaAOWBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:01:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 071/166] firewire: sbp2: bring back WRITE SAME support
Date: Wed, 15 Jan 2014 13:51:25 -0800
Message-Id: <1389822780-4729-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit ce027ed98fd176710fb14be9d6015697b62436f0 upstream.

Commit 54b2b50c20a6 "[SCSI] Disable WRITE SAME for RAID and virtual
host adapter drivers" disabled WRITE SAME support for all SBP-2 attached
targets.  But as described in the changelog of commit b0ea5f19d3d8
"firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED OPERATION CODES",
it is not required to blacklist WRITE SAME.

Bring the feature back by reverting the sbp2.c hunk of commit 54b2b50c20a6.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/firewire/sbp2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4882873..1162d6b 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1628,7 +1628,6 @@ static struct scsi_host_template scsi_driver_template = {
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
-	.no_write_same		= 1,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
-- 
1.8.3.2

