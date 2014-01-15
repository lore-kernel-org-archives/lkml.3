Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaAOVyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:54:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaAOVye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 111/166] auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE
Date: Wed, 15 Jan 2014 13:52:05 -0800
Message-Id: <1389822780-4729-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit f60900f2609e893c7f8d0bccc7ada4947dac4cd5 upstream.

Commit 2171364d1a92 ("powerpc: Add HWCAP2 aux entry") introduced a new
AT_ auxv entry type AT_HWCAP2 but failed to update AT_VECTOR_SIZE_BASE
accordingly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 2171364d1a92 (powerpc: Add HWCAP2 aux entry)
Acked-by: Michael Neuling <michael@neuling.org>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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

