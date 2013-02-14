Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161054Ab3BNWrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:47:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56005 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab3BNWrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:47:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4/9] ARM: omap: add include guard for soc.h
Date: Thu, 14 Feb 2013 23:47:46 +0100
Message-Id: <1360882071-4072668-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:GB8RVrVpMNgVdpfg0IjuBUoNLOcRFf6HA/cgt7oexdd
 KYGsAt8O1Blhw4wK5G1wrSMZ1j4VTUhCLuu4j7W8h74+DT1295
 5s6VjiKUPD3k5br0EMRq5ueZMPg3ScVQT1+vXu5+xfkhPGa1+a
 5WRNKLeUqlEcFpoGnBoHLbA5d7LHGp+CJZs/JBV/UCWWZHsVD7
 +ruU+j2m6tRsfrBKc95oy0ex0GEwpt3V3vfzkTlxEjl0puprkK
 vXWcmApWzGEBYD3nDaIeFoXZ1D2iVhqSf/43ejVzUQp7vhBpdQ
 irxuVvdzLWbdveneGgZpnrfIQyfqQxqKpwuGeEsplUFYo4ndWm
 Lm98yOLPuO4G41bYZxvlzElFPLU6s8bag0/Odqmrr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e4c060db "ARM: OMAP: Split plat/cpu.h into local soc.h for
mach-omap1 and mach-omap2" moved the bulk of "plat/cpu.h" into "cpu.h"
but did not add an include guard for the new file that was present
in the old one. There are cases where the file is indeed included
multiple times, probably by accident, but adding the include
guard ensures that this has no further consequences.

Without this patch, building allmodconfig results in lots of warnings like:

In file included from arch/arm/mach-omap2/drm.c:31:0:
arch/arm/mach-omap2/soc.h:206:0: warning: "cpu_is_omap24xx" redefined [enabled by default]
In file included from arch/arm/mach-omap2/drm.c:28:0:
arch/arm/mach-omap2/soc.h:227:0: note: this is the location of the previous definition
In file included from arch/arm/mach-omap2/drm.c:31:0:
arch/arm/mach-omap2/soc.h:207:0: warning: "cpu_is_omap242x" redefined [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/soc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-omap2/soc.h b/arch/arm/mach-omap2/soc.h
index c62116b..97dd373 100644
--- a/arch/arm/mach-omap2/soc.h
+++ b/arch/arm/mach-omap2/soc.h
@@ -24,6 +24,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  */
+#ifndef OMAP2_SOC_H
+#define OMAP2_SOC_H
 
 #include "omap24xx.h"
 #include "omap34xx.h"
@@ -497,3 +499,4 @@ level(__##fn);
 
 #endif	/* __ASSEMBLY__ */
 
+#endif
-- 
1.8.1.2

