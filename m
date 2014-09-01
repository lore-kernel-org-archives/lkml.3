Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaIAGaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:30:39 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:41185 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbaIAG0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:40 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 27/27] sis_drm.h: hide sis_file_private in userspace
Date: Mon,  1 Sep 2014 09:26:18 +0300
Message-Id: <1409552778-2537-28-git-send-email-mikko.rapeli@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
References: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
 <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 217.30.184.161
X-SA-Exim-Mail-From: mcfrisk@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compiler error:

drm/sis_drm.h:68:19: error: field ‘obj_list’ has incomplete type
  struct list_head obj_list;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/sis_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/sis_drm.h b/include/uapi/drm/sis_drm.h
index df37632..3d0903f 100644
--- a/include/uapi/drm/sis_drm.h
+++ b/include/uapi/drm/sis_drm.h
@@ -64,8 +64,10 @@ typedef struct {
 	unsigned long offset, size;
 } drm_sis_fb_t;
 
+#ifdef __KERNEL__
 struct sis_file_private {
 	struct list_head obj_list;
 };
+#endif
 
 #endif				/* __SIS_DRM_H__ */
-- 
2.1.0

