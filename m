Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaKFWlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58714 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaKFWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, Bob Picco <bob.picco@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 054/162] sparc64: Increase size of boot string to 1024 bytes
Date: Thu,  6 Nov 2014 14:35:18 -0800
Message-Id: <1415313426-9622-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 1cef94c36bd4d79b5ae3a3df99ee0d76d6a4a6dc ]

This is the longest boot string that silo supports.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/prom/bootstr_64.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/prom/bootstr_64.c b/arch/sparc/prom/bootstr_64.c
index ab9ccc6..7149e77 100644
--- a/arch/sparc/prom/bootstr_64.c
+++ b/arch/sparc/prom/bootstr_64.c
@@ -14,7 +14,10 @@
  *          the .bss section or it will break things.
  */
 
-#define BARG_LEN  256
+/* We limit BARG_LEN to 1024 because this is the size of the
+ * 'barg_out' command line buffer in the SILO bootloader.
+ */
+#define BARG_LEN 1024
 struct {
 	int bootstr_len;
 	int bootstr_valid;
-- 
1.9.1

