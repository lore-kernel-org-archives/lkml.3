Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3GXOUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:20:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45878 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418Ab3GXOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Chen Gang" <gang.chen@asianux.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.511511743@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [56/85] powerpc/smp: Section mismatch from smp_release_cpus to
 __initdata spinning_secondaries
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/setup_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -74,7 +74,7 @@
 #endif
 
 int boot_cpuid = 0;
-int __initdata spinning_secondaries;
+int spinning_secondaries;
 u64 ppc64_pft_size;
 
 /* Pick defaults since we might want to patch instructions

