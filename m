Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab3APP7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab3APP7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 029/222] powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build
Date: Wed, 16 Jan 2013 13:53:49 -0200
Message-Id: <1358351822-7675-30-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 11ee7e99f35ecb15f59b21da6a82d96d2cd3fcc8 upstream.

If we build a kernel with CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n,
the kernel fails when we run at a non zero offset. It turns out
we were incorrectly wrapping some of the relocatable kernel code
with CONFIG_CRASH_DUMP.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/powerpc/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 58bddee..9e07bd0 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -422,7 +422,7 @@ _STATIC(__after_prom_start)
 	tovirt(r6,r6)			/* on booke, we already run at PAGE_OFFSET */
 #endif
 
-#ifdef CONFIG_CRASH_DUMP
+#ifdef CONFIG_RELOCATABLE
 /*
  * Check if the kernel has to be running as relocatable kernel based on the
  * variable __run_at_load, if it is set the kernel is treated as relocatable
-- 
1.7.9.5

