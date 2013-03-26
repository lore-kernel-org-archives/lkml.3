Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3CZWoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3CZWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Viljami Ilola <azmulx@netikka.fi>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 55/98] target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os
Date: Tue, 26 Mar 2013 15:42:44 -0700
Message-Id: <20130326224248.252396386@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_file.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


