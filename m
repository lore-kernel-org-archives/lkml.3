Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966948Ab3DRPFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:05:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:56822 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965506Ab3DRPFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:05:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,502,1363132800"; 
   d="scan'208";a="19257271"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <will.deacon@arm.com>, <arnd@arndb.de>, <nicolas.pitre@linaro.org>,
        <Stefano.Stabellini@eu.citrix.com>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <olof@lixom.net>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v7 2/3] arm: prefer psci_smp_ops over mdesc->smp
Date: Thu, 18 Apr 2013 16:05:29 +0100
Message-ID: <1366297530-12497-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304181556210.7254@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304181556210.7254@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PSCI is available on the platform, prefer psci_smp_ops over the
platform smp_ops.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/kernel/setup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 341efaa..dad3048 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -770,10 +770,10 @@ void __init setup_arch(char **cmdline_p)
 	psci_init();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
-		if (mdesc->smp)
-			smp_set_ops(mdesc->smp);
-		else if (psci_smp_available())
+		if (psci_smp_available())
 			smp_set_ops(&psci_smp_ops);
+		else if (mdesc->smp)
+			smp_set_ops(mdesc->smp);
 		smp_init_cpus();
 	}
 #endif
-- 
1.7.2.5

