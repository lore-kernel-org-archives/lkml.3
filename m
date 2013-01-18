Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3ARM01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:26:27 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:55782 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3ARM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:26:24 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 04/76] asm-generic headers: uaccess.h to conditionally define segment_eq()
Date: Fri, 18 Jan 2013 17:54:18 +0530
Message-ID: <1358511930-7424-5-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is because mm_segment_t is exported by arch code, while seqment_eq
assumes it will have .seg element.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 include/asm-generic/uaccess.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index 9788568..5f6ee61 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -7,7 +7,6 @@
  * address space, e.g. all NOMMU machines.
  */
 #include <linux/sched.h>
-#include <linux/mm.h>
 #include <linux/string.h>
 
 #include <asm/segment.h>
@@ -32,7 +31,9 @@ static inline void set_fs(mm_segment_t fs)
 }
 #endif
 
+#ifndef segment_eq
 #define segment_eq(a, b) ((a).seg == (b).seg)
+#endif
 
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
-- 
1.7.4.1

