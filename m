Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbaHYVy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:54:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:11445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933671AbaHYVym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:54:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,398,1406617200"; 
   d="scan'208";a="563299715"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 10/10] mei: move mei_hbm_hdr function from hbm.h the hbm.c
Date: Tue, 26 Aug 2014 00:53:28 +0300
Message-Id: <1409003608-30274-10-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
References: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_hbm_hder helper function is only used in hbm.c
so there is no need to define it in a header file

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 16 ++++++++++++++++
 drivers/misc/mei/hbm.h |  9 ---------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 24534ff..6fe4dfd6 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -134,6 +134,22 @@ void mei_hbm_reset(struct mei_device *dev)
 }
 
 /**
+ * mei_hbm_dr - construct hbm header
+ *
+ * @hdr: client
+ * @length: payload lenght
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

