Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaIAG0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:42 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:59552 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbaIAG0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:40 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 25/27] via_drm.h: hide struct via_file_private in userspace
Date: Mon,  1 Sep 2014 09:26:16 +0300
Message-Id: <1409552778-2537-26-git-send-email-mikko.rapeli@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
References: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
 <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
X-SA-Exim-Connect-IP: 217.30.184.161
X-SA-Exim-Mail-From: mcfrisk@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compiler error since list_head is not exported to userspace headers.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/via_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/via_drm.h b/include/uapi/drm/via_drm.h
index 791531e..34ce658 100644
--- a/include/uapi/drm/via_drm.h
+++ b/include/uapi/drm/via_drm.h
@@ -272,8 +272,10 @@ typedef struct drm_via_dmablit {
 	drm_via_blitsync_t sync;
 } drm_via_dmablit_t;
 
+#ifdef __KERNEL__
 struct via_file_private {
 	struct list_head obj_list;
 };
+#endif
 
 #endif				/* _VIA_DRM_H_ */
-- 
2.1.0

