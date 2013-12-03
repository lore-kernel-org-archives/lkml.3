Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3LCOvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:51:17 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62392 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3LCOvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:13 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/9] staging/lustre/obdclass: fix false used uninitialized warning
Date: Tue,  3 Dec 2013 22:41:58 +0800
Message-Id: <1386081729-9481-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got below warning when building lustre with 4.7.3.
drivers/staging/lustre/lustre/obdclass/llog_test.c: In function ‘
llog_test_init’:
drivers/staging/lustre/lustre/obdclass/llog_test.c:1058:28: warning: ‘
lvars.module_vars’ is used uninitialized in this function
[-Wuninitialized]

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/llog_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/llog_test.c b/drivers/staging/lustre/lustre/obdclass/llog_test.c
index 178f89e..7427c12 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_test.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_test.c
@@ -1048,7 +1048,7 @@ static struct obd_ops llog_obd_ops = {
 
 static int __init llog_test_init(void)
 {
-	struct lprocfs_static_vars lvars;
+	struct lprocfs_static_vars uninitialized_var(lvars);
 
 	lprocfs_llog_test_init_vars(&lvars);
 	return class_register_type(&llog_obd_ops, NULL,
-- 
1.7.9.5

