Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3GVJsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:48:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19680 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025Ab3GVJsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:48:12 -0400
X-IronPort-AV: E=Sophos;i="4.89,718,1367971200"; 
   d="scan'208";a="38382769"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <catalin.marinas@arm.com>, <stefano.stabellini@eu.citrix.com>,
        <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v2] xen/arm and xen/arm64: update xen_restart after ff701306cd49
Date: Mon, 22 Jul 2013 10:47:44 +0100
Message-ID: <1374486464-25243-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ff701306cd49 (arm64: use common reboot infrastructure) changes
the prototype of arm_pm_restart.  Update xen_restart accordingly.

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

