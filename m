Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3AXDiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:38:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44330 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3AXDa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Schwinge <thomas@codesourcery.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 45/74] sh: Fix FDPIC binary loader
Date: Thu, 24 Jan 2013 01:26:57 -0200
Message-Id: <1358998046-613-46-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Schwinge <thomas@codesourcery.com>

commit 4a71997a3279a339e7336ea5d0cd27282e2dea44 upstream.

Ensure that the aux table is properly initialized, even when optional features
are missing.  Without this, the FDPIC loader did not work.  This was meant to
be included in commit d5ab780305bb6d60a7b5a74f18cf84eb6ad153b1.

Signed-off-by: Thomas Schwinge <thomas@codesourcery.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/sh/include/asm/elf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/elf.h b/arch/sh/include/asm/elf.h
index f38112b..978b7fd 100644
--- a/arch/sh/include/asm/elf.h
+++ b/arch/sh/include/asm/elf.h
@@ -202,9 +202,9 @@ extern void __kernel_vsyscall;
 	if (vdso_enabled)					\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE);	\
 	else							\
-		NEW_AUX_ENT(AT_IGNORE, 0);
+		NEW_AUX_ENT(AT_IGNORE, 0)
 #else
-#define VSYSCALL_AUX_ENT
+#define VSYSCALL_AUX_ENT	NEW_AUX_ENT(AT_IGNORE, 0)
 #endif /* CONFIG_VSYSCALL */
 
 #ifdef CONFIG_SH_FPU
-- 
1.7.9.5

