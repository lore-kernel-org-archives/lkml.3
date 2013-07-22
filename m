Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab3GVQTp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 22 Jul 2013 12:19:45 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52189 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab3GVQLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:54 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fan Yong <yong.fan@whamcloud.com>,
        Fan Yong <fan.yong@intel.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 25/48] staging/lustre/lfsck: LFSCK 1.5 technical debts (3)
Date: Tue, 23 Jul 2013 00:06:46 +0800
Message-Id: <1374509230-3324-26-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <yong.fan@whamcloud.com>

Original patch resolves some LFSCK 1.5 technical debts, including:
1) Check and remove repeated linkea entries.
2) Merge some "goto" branches to make the code more readable.
3) Some comments about object's nlink inconsistency processing.

This patch picks the obd flags change.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2915
Lustre-change: http://review.whamcloud.com/6344
Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/obd_support.h    |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index b5d40af..03e6133 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -470,6 +470,7 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
 #define OBD_FAIL_LFSCK_DELAY3		0x1602
 #define OBD_FAIL_LFSCK_LINKEA_CRASH	0x1603
 #define OBD_FAIL_LFSCK_LINKEA_MORE	0x1604
+#define OBD_FAIL_LFSCK_LINKEA_MORE2	0x1605
 #define OBD_FAIL_LFSCK_FATAL1		0x1608
 #define OBD_FAIL_LFSCK_FATAL2		0x1609
 #define OBD_FAIL_LFSCK_CRASH		0x160a
-- 
1.7.9.5

