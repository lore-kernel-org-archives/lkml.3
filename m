Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaH0HAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:00:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:42240 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaH0HAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:00:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="563994703"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 10/10] mei: move mei_hbm_hdr function from hbm.h the hbm.c
Date: Wed, 27 Aug 2014 09:59:32 +0300
Message-Id: <1409122772-19906-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_hbm_hder helper function is only used in hbm.c
so there is no need to define it in a header file

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: fix kdoc
 drivers/misc/mei/hbm.c | 16 ++++++++++++++++
 drivers/misc/mei/hbm.h |  9 ---------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 24534ff..a7eb244 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -134,6 +134,22 @@ void mei_hbm_reset(struct mei_device *dev)
 }
 
 /**
+ * mei_hbm_hdr - construct hbm header
+ *
+ * @hdr: hbm header
+ * @length: payload length
+ */
+
+static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
+{
+	hdr->host_addr = 0;
+	hdr->me_addr = 0;
+	hdr->length = length;
+	hdr->msg_complete = 1;
+	hdr->reserved = 0;
+}
+
+/**
  * mei_hbm_cl_hdr - construct client hbm header
  *
  * @cl: client
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index efcb0d4..b7cd3d8 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -44,15 +44,6 @@ const char *mei_hbm_state_str(enum mei_hbm_state state);
 
 int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr);
 
-static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
-{
-	hdr->host_addr = 0;
-	hdr->me_addr = 0;
-	hdr->length = length;
-	hdr->msg_complete = 1;
-	hdr->reserved = 0;
-}
-
 void mei_hbm_idle(struct mei_device *dev);
 void mei_hbm_reset(struct mei_device *dev);
 int mei_hbm_start_req(struct mei_device *dev);
-- 
1.9.3

