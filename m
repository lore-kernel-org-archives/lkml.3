Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaIAG04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:56 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:47105 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbaIAG0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:50 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 14/27] cld.h: include stdint.h in userspace
Date: Mon,  1 Sep 2014 09:26:05 +0300
Message-Id: <1409552778-2537-15-git-send-email-mikko.rapeli@iki.fi>
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

Fixes compilation error:

linux/nfsd/cld.h:40:2: error: unknown type name ‘uint16_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/nfsd/cld.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/nfsd/cld.h b/include/uapi/linux/nfsd/cld.h
index f14a9ab..9f60f9c 100644
--- a/include/uapi/linux/nfsd/cld.h
+++ b/include/uapi/linux/nfsd/cld.h
@@ -22,6 +22,12 @@
 #ifndef _NFSD_CLD_H
 #define _NFSD_CLD_H
 
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
 /* latest upcall version available */
 #define CLD_UPCALL_VERSION 1
 
-- 
2.1.0

