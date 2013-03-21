Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3CUTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:16:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6974 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab3CUTQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:16:54 -0400
X-IronPort-AV: E=Sophos;i="4.84,888,1355097600"; 
   d="scan'208";a="14091266"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <marc.zyngier@arm.com>, <will.deacon@arm.com>, <arnd@arndb.de>,
        <rob.herring@calxeda.com>
Subject: [PATCH 3/4] xen: move the xenvm machine to mach-virt
Date: Thu, 21 Mar 2013 19:16:19 +0000
Message-ID: <1363893380-14309-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1303211848150.5135@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303211848150.5135@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xenvm is based on mach-vexpress, move it to mach-virt.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: marc.zyngier@arm.com
CC: will.deacon@arm.com
CC: arnd@arndb.de
CC: rob.herring@calxeda.com
---
 arch/arm/mach-vexpress/v2m.c |    1 -
 arch/arm/mach-virt/virt.c    |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

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

