Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3DYQ7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:59:17 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28639 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626Ab3DYQ6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:58:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,551,1363132800"; 
   d="scan'208";a="21599748"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <marc.zyngier@arm.com>, <will.deacon@arm.com>,
        <arnd@arndb.de>, <rob.herring@calxeda.com>
Subject: [PATCH v5 4/7] xen: move the xenvm machine to mach-virt
Date: Thu, 25 Apr 2013 17:57:52 +0100
Message-ID: <1366909075-28775-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304251750160.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304251750160.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xenvm is based on mach-vexpress, move it to mach-virt.

Changes in v4:
- update the dts Makefile too.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Marc Zyngier <marc.zyngier@arm.com>
CC: will.deacon@arm.com
CC: arnd@arndb.de
CC: rob.herring@calxeda.com
---
 arch/arm/boot/dts/Makefile   |    4 ++--
 arch/arm/mach-vexpress/v2m.c |    1 -
 arch/arm/mach-virt/virt.c    |    1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 9c62558..b6289b7 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -168,8 +168,8 @@ dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 dtb-$(CONFIG_ARCH_VEXPRESS) += vexpress-v2p-ca5s.dtb \
 	vexpress-v2p-ca9.dtb \
 	vexpress-v2p-ca15-tc1.dtb \
-	vexpress-v2p-ca15_a7.dtb \
-	xenvm-4.2.dtb
+	vexpress-v2p-ca15_a7.dtb
+dtb-$(CONFIG_ARCH_VIRT) += xenvm-4.2.dtb
 dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8505-ref.dtb \
 	wm8650-mid.dtb \
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 915683c..c43ec78 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -469,7 +469,6 @@ static void __init v2m_dt_init(void)
 
 static const char * const v2m_dt_match[] __initconst = {
 	"arm,vexpress",
-	"xen,xenvm",
 	NULL,
 };
 
diff --git a/arch/arm/mach-virt/virt.c b/arch/arm/mach-virt/virt.c
index 31666f6..528c05e 100644
--- a/arch/arm/mach-virt/virt.c
+++ b/arch/arm/mach-virt/virt.c
@@ -40,6 +40,7 @@ static void __init virt_timer_init(void)
 
 static const char *virt_dt_match[] = {
 	"linux,dummy-virt",
+	"xen,xenvm",
 	NULL
 };
 
-- 
1.7.2.5

