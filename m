Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab3KNQxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:53:13 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59911 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab3KNQkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:12 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 27/39] staging/lustre/mdt: HSM EXIST event not triggered at last rm/mv
Date: Fri, 15 Nov 2013 00:32:50 +0800
Message-Id: <1384446782-13741-28-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

After a rm or mv, if the target file is destroyed
(last unlink) and if there is an archive in the backend
a flags must be set in changelog event

Lustre-change: http://review.whamcloud.com/7260
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3718
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
[pick up only lustre_user.h change -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 2c72a88..0ad524a 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -692,7 +692,10 @@ static inline const char *changelog_type2str(int type) {
 #define CLF_UNLINK_HSM_EXISTS 0x0002 /* File has something in HSM */
 				     /* HSM cleaning needed */
 /* Flags for rename */
-#define CLF_RENAME_LAST       0x0001 /* rename unlink last hardlink of target */
+#define CLF_RENAME_LAST		0x0001 /* rename unlink last hardlink
+					* of target */
+#define CLF_RENAME_LAST_EXISTS	0x0002 /* rename unlink last hardlink of target
+					* has an archive in backend */
 
 /* Flags for HSM */
 /* 12b used (from high weight to low weight):
-- 
1.7.9.5

