Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbbALS1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:27:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57516 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbbALSF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sumit Saxena <sumit.saxena@avagotech.com>,
        Kashyap Desai <kashyap.desai@avagotech.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 045/216] megaraid_sas: corrected return of wait_event from abort frame path
Date: Mon, 12 Jan 2015 18:02:42 +0000
Message-Id: <1421085933-32536-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>

commit 170c238701ec38b1829321b17c70671c101bac55 upstream.

Corrected wait_event() call which was waiting for wrong completion
status (0xFF).

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 112799b131a9..8677fa0deb2d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -980,7 +980,7 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 		cpu_to_le32(upper_32_bits(cmd_to_abort->frame_phys_addr));
 
 	cmd->sync_cmd = 1;
-	cmd->cmd_status = 0xFF;
+	cmd->cmd_status = ENODATA;
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
-- 
2.1.4

