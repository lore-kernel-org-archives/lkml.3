Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaIPVrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:47:13 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60231 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbaIPVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:47:08 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>
Date: Tue, 16 Sep 2014 23:38:55 +0000
Message-Id: <1410910735-27929-19-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 18/18] usbip: list.h include stddef.h for offsetof
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove offsetof macro from list.h and use builtin macro defined in
stddef.h to avoid multiple declaration error in gcc 4.7.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
---
 tools/usb/usbip/libsrc/list.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/usb/usbip/libsrc/list.h b/tools/usb/usbip/libsrc/list.h
index 8d0c936..a3dca5a 100644
--- a/tools/usb/usbip/libsrc/list.h
+++ b/tools/usb/usbip/libsrc/list.h
@@ -15,6 +15,8 @@
  * using the generic single-entry routines.
  */
 
+#include <stddef.h>
+
 struct list_head {
 	struct list_head *next, *prev;
 };
@@ -120,7 +122,6 @@ static inline void list_del(struct list_head *entry)
 	for (pos = (head)->next, n = pos->next; pos != (head); \
 		pos = n, n = pos->next)
 
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 
 /**
  * container_of - cast a member of a structure out to the containing structure
-- 
2.1.0

