Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3C2QnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:43:05 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18065 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab3C2QnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:43:03 -0400
X-IronPort-AV: E=Sophos;i="4.87,373,1363132800"; 
   d="scan'208";a="15642240"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <arnd@arndb.de>, <marc.zyngier@arm.com>,
        <linux@arm.linux.org.uk>, <nico@linaro.org>
Subject: [PATCH v4 2/2] arm: prefer PSCI for SMP bringup
Date: Fri, 29 Mar 2013 16:42:50 +0000
Message-ID: <1364575371-8926-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PSCI initializes correctly and PSCI SMP operations are available, use them.
This is required for SMP support in Dom0 on Xen.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: will.deacon@arm.com
CC: arnd@arndb.de
CC: marc.zyngier@arm.com
CC: linux@arm.linux.org.uk
CC: nico@linaro.org
---
 arch/arm/kernel/setup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 341efaa..c7e50dd 100644
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
+		else
+			smp_set_ops(mdesc->smp);
 		smp_init_cpus();
 	}
 #endif
-- 
1.7.2.5

