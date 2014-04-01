Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaDAQKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:10:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44484 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaDAQKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:10:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 64/86] [SCSI] qla2xxx: Poll during initialization for ISP25xx and ISP83xx
Date: Tue,  1 Apr 2014 09:08:17 -0700
Message-Id: <1396368519-12728-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

commit b77ed25c9f8402e8b3e49e220edb4ef09ecfbb53 upstream.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6e7727f..0e703a0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2764,8 +2764,7 @@ struct qla_hw_data {
 				IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
 				IS_QLA82XX(ha) || IS_QLA83XX(ha))
 #define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha) || IS_QLA83XX(ha))
-#define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
-			IS_QLA83XX(ha)) && (ha)->flags.msix_enabled)
+#define IS_NOPOLLING_TYPE(ha)	(IS_QLA81XX(ha) && (ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha))
 #define IS_NOCACHE_VPD_TYPE(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha))
 #define IS_ALOGIO_CAPABLE(ha)	(IS_QLA23XX(ha) || IS_FWI2_CAPABLE(ha))
-- 
1.8.3.2

