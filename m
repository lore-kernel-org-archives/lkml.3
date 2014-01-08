Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbaAHUju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:39:50 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:49854 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbaAHUgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:36:24 -0500
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 05/14] target/spc: Add protection bit to standard INQUIRY output
Date: Wed,  8 Jan 2014 20:15:48 +0000
Message-Id: <1389212157-14540-6-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates spc_emulate_inquiry_std() to set the
PROTECT bit when DIF emulation is enabled by the backend
device.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 021c3f4..6b06f01 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -100,6 +100,11 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	 */
 	if (dev->dev_attrib.emulate_3pc)
 		buf[5] |= 0x8;
+	/*
+	 * Set Protection (PROTECT) bit when DIF has been enabled.
+	 */
+	if (dev->dev_attrib.pi_prot_type)
+		buf[5] |= 0x1;
 
 	buf[7] = 0x2; /* CmdQue=1 */
 
-- 
1.7.10.4

