Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbaIOWLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:11:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaIOWLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 096/187] Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by the Host
Date: Mon, 15 Sep 2014 15:08:26 -0700
Message-Id: <1410818997-9432-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 52f9614dd8294e95d2c0929c2d4f64b077ae486f upstream.

Set cmd_per_lun to reflect value supported by the Host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/storvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8938b13..cebcef7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1690,7 +1690,7 @@ static struct scsi_host_template scsi_driver = {
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
-	.cmd_per_lun =		1,
+	.cmd_per_lun =		255,
 	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
 	.this_id =		-1,
 	/* no use setting to 0 since ll_blk_rw reset it to 1 */
-- 
1.9.1

