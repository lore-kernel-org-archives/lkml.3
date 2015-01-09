Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbbAIKiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:38:23 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44612 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757511AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>,
        Sumit Saxena <sumit.saxena@avagotech.com>,
        Kashyap Desai <kashyap.desai@avagotech.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 42/78] megaraid_sas: corrected return of wait_event from abort frame path
Date: Fri,  9 Jan 2015 11:31:51 +0100
Message-Id: <fe882bbc67689d331bf45fd3b77f63a989b25d3b.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 170c238701ec38b1829321b17c70671c101bac55 upstream.

Corrected wait_event() call which was waiting for wrong completion
status (0xFF).

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a59a5526a318..855dc7c4cad7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -953,7 +953,7 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 		cpu_to_le32(upper_32_bits(cmd_to_abort->frame_phys_addr));
 
 	cmd->sync_cmd = 1;
-	cmd->cmd_status = 0xFF;
+	cmd->cmd_status = ENODATA;
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
-- 
2.2.1

