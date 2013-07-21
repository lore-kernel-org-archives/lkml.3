Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3GUPY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:24:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:17706 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab3GUPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:24:28 -0400
X-IronPort-AV: E=Sophos;i="4.89,713,1367971200"; 
   d="scan'208";a="36452971"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <catalin.marinas@arm.com>
CC: <marc.zyngier@arm.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] xen/arm and xen/arm64: update xen_restart after ff701306cd49
Date: Sun, 21 Jul 2013 16:24:17 +0100
Message-ID: <1374420257-19467-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ff701306cd49 changes the prototype of arm_pm_restart.
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

