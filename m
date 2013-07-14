Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3GNXG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:06:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3GNXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, oliver@schinagl.nl, linux@roeck-us.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 10/10] sysfs: use file mode defines from stat.h
Date: Sun, 14 Jul 2013 16:06:00 -0700
Message-Id: <1373843160-3990-11-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

With the last patches stat.h was included to the header, and thus those
permission defines should be used.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sysfs.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index d907a732..9e8a9b55 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -69,18 +69,19 @@ struct attribute_group {
  * for examples..
  */
 
-#define __ATTR(_name,_mode,_show,_store) { \
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show	= _show,					\
-	.store	= _store,					\
+#define __ATTR(_name,_mode,_show,_store) { 				\
+	.attr = {.name = __stringify(_name), .mode = _mode },		\
+	.show	= _show,						\
+	.store	= _store,						\
 }
 
-#define __ATTR_RO(_name) { \
-	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
-	.show	= _name##_show,					\
+#define __ATTR_RO(_name) {						\
+	.attr	= { .name = __stringify(_name), .mode = S_IRUGO },	\
+	.show	= _name##_show,						\
 }
 
-#define __ATTR_RW(_name) __ATTR(_name, 0644, _name##_show, _name##_store)
+#define __ATTR_RW(_name) __ATTR(_name, (S_IWUSR | S_IRUGO),		\
+			 _name##_show, _name##_store)
 
 #define __ATTR_NULL { .attr = { .name = NULL } }
 
-- 
1.8.3.rc0.20.gb99dd2e

