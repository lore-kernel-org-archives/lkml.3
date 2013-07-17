Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934656Ab3GQXA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:00:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab3GQW4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 052/145] powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries
Date: Wed, 17 Jul 2013 15:46:24 -0700
Message-Id: <1374101277-7915-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 8246aca7058f3f2c2ae503081777965cd8df7b90 upstream.

the smp_release_cpus is a normal funciton and called in normal environments,
  but it calls the __initdata spinning_secondaries.
  need modify spinning_secondaries to match smp_release_cpus.

the related warning:
  (the linker report boot_paca.33377, but it should be spinning_secondaries)

-----------------------------------------------------------------------------

WARNING: arch/powerpc/kernel/built-in.o(.text+0x23176): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33377
The function .smp_release_cpus() references
the variable __initdata boot_paca.33377.
This is often because .smp_release_cpus lacks a __initdata
annotation or the annotation of boot_paca.33377 is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x231fe): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33377
The function .smp_release_cpus() references
the variable __initdata boot_paca.33377.
This is often because .smp_release_cpus lacks a __initdata
annotation or the annotation of boot_paca.33377 is wrong.

-----------------------------------------------------------------------------

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/setup_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 8d97eb4..7960d9c 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -76,7 +76,7 @@
 #endif
 
 int boot_cpuid = 0;
-int __initdata spinning_secondaries;
+int spinning_secondaries;
 u64 ppc64_pft_size;
 
 /* Pick defaults since we might want to patch instructions
-- 
1.8.1.2

