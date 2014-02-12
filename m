Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaBLITz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:19:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50301 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbaBLIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:10 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "Tony Luck" <tony.luck@intel.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.562430222@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 22/79] [IA64] Fix warning from machine_kexec.c
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit c19ce0ab53ad9698968a154647f3dc22aad6c45b upstream.

Use proper cpp defined(...) constructs to avoid this:

arch/ia64/kernel/machine_kexec.c: In function 'arch_crash_save_vmcoreinfo':
arch/ia64/kernel/machine_kexec.c:160:8: warning: "CONFIG_PGTABLE_4" is not defined

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/ia64/kernel/machine_kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
index 4eed358..070e8ef 100644
--- a/arch/ia64/kernel/machine_kexec.c
+++ b/arch/ia64/kernel/machine_kexec.c
@@ -157,7 +157,7 @@ void arch_crash_save_vmcoreinfo(void)
 #endif
 #ifdef CONFIG_PGTABLE_3
 	VMCOREINFO_CONFIG(PGTABLE_3);
-#elif  CONFIG_PGTABLE_4
+#elif defined(CONFIG_PGTABLE_4)
 	VMCOREINFO_CONFIG(PGTABLE_4);
 #endif
 }

