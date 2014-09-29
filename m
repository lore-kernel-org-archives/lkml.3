Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaI2L7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:59:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbaI2L7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:18 -0400
From: Hannes Reinecke <hare@suse.de>
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 33/38] libata: use __scsi_print_command()
Date: Mon, 29 Sep 2014 13:59:02 +0200
Message-Id: <1411991947-130166-34-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libata already uses an internal buffer, so we should be using
__scsi_print_command() here.

Cc: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index dad83df..74c5652 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2509,15 +2509,11 @@ static void ata_eh_link_report(struct ata_link *link)
 
 		if (ata_is_atapi(qc->tf.protocol)) {
 			if (qc->scsicmd)
-				scsi_print_command(qc->scsicmd);
+				__scsi_print_command(cdb_buf, sizeof(cdb_buf),
+						     qc->scsicmd->cmnd);
 			else
-				snprintf(cdb_buf, sizeof(cdb_buf),
-				 "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
-				 cdb[0], cdb[1], cdb[2], cdb[3],
-				 cdb[4], cdb[5], cdb[6], cdb[7],
-				 cdb[8], cdb[9], cdb[10], cdb[11],
-				 cdb[12], cdb[13], cdb[14], cdb[15]);
+				__scsi_print_command(cdb_buf, sizeof(cdb_buf),
+						     (unsigned char *)cdb);
 		} else {
 			const char *descr = ata_get_cmd_descript(cmd->command);
 			if (descr)
-- 
1.8.5.2

