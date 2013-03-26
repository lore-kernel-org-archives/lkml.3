Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845Ab3CZPri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:47:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965109Ab3CZPXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 083/150] target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os
Date: Tue, 26 Mar 2013 15:19:42 +0000
Message-Id: <1364311249-14454-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit f002a24388cc460c8a9be7d446a9871f7c9d52b6 upstream.

This patch bumps the default FILEIO backend FD_MAX_SECTORS value from
1024 -> 2048 in order to allow block_size=512 to handle 1M sized I/Os.

The current default rejects I/Os larger than 512K in sbc_parse_cdb():

[12015.915146] SCSI OP 2ah with too big sectors 1347 exceeds backend
hw_max_sectors: 1024
[12015.977744] SCSI OP 2ah with too big sectors 2048 exceeds backend
hw_max_sectors: 1024

This issue is present in >= v3.5 based kernels, introduced after the
removal of se_task logic.

Reported-by: Viljami Ilola <azmulx@netikka.fi>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_file.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 876ae53..291f66e 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -7,7 +7,7 @@
 #define FD_DEVICE_QUEUE_DEPTH	32
 #define FD_MAX_DEVICE_QUEUE_DEPTH 128
 #define FD_BLOCKSIZE		512
-#define FD_MAX_SECTORS		1024
+#define FD_MAX_SECTORS		2048
 
 #define RRF_EMULATE_CDB		0x01
 #define RRF_GOT_LBA		0x02
-- 
1.8.1.2

