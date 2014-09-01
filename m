Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaIAGc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:32:58 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:49950 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbaIAG0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:30 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 09/27] radeon_drm.h: include stdint.h in userspace
Date: Mon,  1 Sep 2014 09:26:00 +0300
Message-Id: <1409552778-2537-10-git-send-email-mikko.rapeli@iki.fi>
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

drm/radeon_drm.h:794:2: error: unknown type name ‘uint64_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/radeon_drm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/drm/radeon_drm.h b/include/uapi/drm/radeon_drm.h
index aefa2f6..6b12bbb7 100644
--- a/include/uapi/drm/radeon_drm.h
+++ b/include/uapi/drm/radeon_drm.h
@@ -33,6 +33,11 @@
 #ifndef __RADEON_DRM_H__
 #define __RADEON_DRM_H__
 
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
 #include <drm/drm.h>
 
 /* WARNING: If you change any of these defines, make sure to change the
-- 
2.1.0

