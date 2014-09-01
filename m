Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaIAG05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:57 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:54158 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbaIAG0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:50 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 12/27] hsi_char.h: include stdint.h in userspace
Date: Mon,  1 Sep 2014 09:26:03 +0300
Message-Id: <1409552778-2537-13-git-send-email-mikko.rapeli@iki.fi>
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

linux/hsi/hsi_char.h:51:2: error: unknown type name ‘uint32_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/hsi/hsi_char.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/hsi/hsi_char.h b/include/uapi/linux/hsi/hsi_char.h
index 76160b4..9fa8f91 100644
--- a/include/uapi/linux/hsi/hsi_char.h
+++ b/include/uapi/linux/hsi/hsi_char.h
@@ -20,10 +20,15 @@
  * 02110-1301 USA
  */
 
-
 #ifndef __HSI_CHAR_H
 #define __HSI_CHAR_H
 
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
 #define HSI_CHAR_MAGIC		'k'
 #define HSC_IOW(num, dtype)	_IOW(HSI_CHAR_MAGIC, num, dtype)
 #define HSC_IOR(num, dtype)	_IOR(HSI_CHAR_MAGIC, num, dtype)
-- 
2.1.0

