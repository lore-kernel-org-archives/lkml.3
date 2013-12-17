Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3LQUwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:52:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20105 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3LQUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v11 11/12] xen/pvh: Disable PV code that does not work with PVH.
Date: Tue, 17 Dec 2013 15:51:42 -0500
Message-Id: <1387313503-31362-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

As we do not have yet a mechanism for that.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/cpu_hotplug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index cc6513a..cbb02af 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -4,6 +4,7 @@
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
+#include <xen/features.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/cpu.h>
@@ -102,7 +103,8 @@ static int __init setup_vcpu_hotplug_event(void)
 	static struct notifier_block xsn_cpu = {
 		.notifier_call = setup_cpu_watcher };
 
-	if (!xen_pv_domain())
+	/* PVH TBD/FIXME: future work */
+	if (!xen_pv_domain() || xen_feature(XENFEAT_auto_translated_physmap))
 		return -ENODEV;
 
 	register_xenstore_notifier(&xsn_cpu);
-- 
1.8.3.1

