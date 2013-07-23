Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3GWMBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:01:24 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56818 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab3GWMBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:01:23 -0400
X-IronPort-AV: E=Sophos;i="4.89,727,1367971200"; 
   d="scan'208";a="38674034"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <konrad.wilk@oracle.com>, <Marc.Zyngier@arm.com>,
        <sergei.shtylyov@cogentembedded.com>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3] xen/arm,arm64: update xen_restart after ff701306cd49 and 7b6d864b48d9
Date: Tue, 23 Jul 2013 13:01:17 +0100
Message-ID: <1374580878-22202-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7b6d864b48d9 (reboot: arm: change reboot_mode to use enum
reboot_mode) and ff701306cd49 (arm64: use common reboot infrastructure)
change the prototype of arm_pm_restart on arm and arm64.
Update xen_restart accordingly.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index f71c37e..c9770ba 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -172,7 +172,7 @@ static void __init xen_percpu_init(void *unused)
 	enable_percpu_irq(xen_events_irq, 0);
 }
 
-static void xen_restart(char str, const char *cmd)
+static void xen_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 	struct sched_shutdown r = { .reason = SHUTDOWN_reboot };
 	int rc;
-- 
1.7.2.5

