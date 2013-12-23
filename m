Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3LWRuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:50:07 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37870 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab3LWRuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:50:03 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        gregkh@linuxfoundation.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE
Date: Mon, 23 Dec 2013 18:49:30 +0100
Message-Id: <1387820970-6949-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2171364d1a92 (powerpc: Add HWCAP2 aux entry) introduced a new
AT_ auxv entry type AT_HWCAP2 but failed to update AT_VECTOR_SIZE_BASE
accordingly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 2171364d1a92 (powerpc: Add HWCAP2 aux entry)
Cc: stable@vger.kernel.org
---

 include/linux/auxvec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 669fef5..3e0fbe4 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -3,6 +3,6 @@
 
 #include <uapi/linux/auxvec.h>
 
-#define AT_VECTOR_SIZE_BASE 19 /* NEW_AUX_ENT entries in auxiliary table */
+#define AT_VECTOR_SIZE_BASE 20 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 #endif /* _LINUX_AUXVEC_H */
-- 
1.8.3.2

