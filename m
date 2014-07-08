Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaGHW0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:26:44 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55313 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaGHW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:42 -0400
Date: Wed, 9 Jul 2014 03:56:34 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Russell King <linux@arm.linux.org.uk>, xen-devel@lists.xenproject.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] xen/arm: use BUG_ON
Message-ID: <20140708222634.GA11976@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 arch/arm/xen/enlighten.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 1e63243..98544c5 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -181,8 +181,7 @@ static void xen_restart(enum reboot_mode reboot_mode, const char *cmd)
 	struct sched_shutdown r = { .reason = SHUTDOWN_reboot };
 	int rc;
 	rc = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
-	if (rc)
-		BUG();
+	BUG_ON(rc);
 }
 
 static void xen_power_off(void)
@@ -190,8 +189,7 @@ static void xen_power_off(void)
 	struct sched_shutdown r = { .reason = SHUTDOWN_poweroff };
 	int rc;
 	rc = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
-	if (rc)
-		BUG();
+	BUG_ON(rc);
 }
 
 static int xen_cpu_notification(struct notifier_block *self,
-- 
1.9.1

