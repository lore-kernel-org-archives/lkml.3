Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab3DKUbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:31:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5882 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab3DKU0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:16 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=I8clSAwXQwEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=L2RovhSkd_0A:10 a=z11f-joXAAAA:8 a=VwQbUJbxAAAA:8 a=a2lwGOApAAAA:8 a=U3ardj3JYD-QTbrvxZIA:9 a=MJMu1F_l1n8A:10 a=CJVq-v20pXUA:10 a=jeBq3FmKZ4MA:10 a=01V5qQrAQNsA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202554.019071242@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Viljami Ilola <azmulx@netikka.fi>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 048/171 ] target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0048-target-file-Bump-FD_MAX_SECTORS-to-2048-to-handle-1M.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

[ Upstream commit f002a24388cc460c8a9be7d446a9871f7c9d52b6 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/target/target_core_file.h |    2 +-
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
1.7.10.4


