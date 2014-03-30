Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaC3XtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:49:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769AbaC3Xns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "James Bottomley" <JBottomley@Parallels.com>,
        "Giridhar Malavali" <giridhar.malavali@qlogic.com>,
        "Saurav Kashyap" <saurav.kashyap@qlogic.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.610195745@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 171/200] [SCSI] qla2xxx: Poll during initialization
 for ISP25xx and ISP83xx
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

commit b77ed25c9f8402e8b3e49e220edb4ef09ecfbb53 upstream.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2:
 - Adjust context
 - QLA83XX was not included]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/qla2xxx/qla_def.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2568,8 +2568,7 @@ struct qla_hw_data {
 				IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
 				IS_QLA82XX(ha))
 #define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha))
-#define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && \
-				(ha)->flags.msix_enabled)
+#define IS_NOPOLLING_TYPE(ha)	(IS_QLA81XX(ha) && (ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha))
 #define IS_NOCACHE_VPD_TYPE(ha)	(IS_QLA81XX(ha))
 #define IS_ALOGIO_CAPABLE(ha)	(IS_QLA23XX(ha) || IS_FWI2_CAPABLE(ha))

