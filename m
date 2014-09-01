Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaIAG0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:36 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:59977 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbaIAG0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:30 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 05/27] drm.h: include stdlib.h in userspace
Date: Mon,  1 Sep 2014 09:25:56 +0300
Message-Id: <1409552778-2537-6-git-send-email-mikko.rapeli@iki.fi>
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

Fixes <drm/drm.h> compilation error:

drm/drm.h:132:2: error: unknown type name ‘size_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/drm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index 9abbeb9..820fd01 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -42,6 +42,10 @@
 #include <asm/ioctl.h>
 typedef unsigned int drm_handle_t;
 
+#ifndef __KERNEL__
+#include <stdlib.h>
+#endif
+
 #else /* One of the BSDs */
 
 #include <sys/ioccom.h>
-- 
2.1.0

