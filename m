Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaAAEiy (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:38:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18510 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaAAEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v12 17/18] xen/pvh/arm/arm64: Disable PV code that does not work with PVH (v2)
Date: Tue, 31 Dec 2013 23:35:44 -0500
Message-Id: <1388550945-25499-18-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

As we do not have yet a mechanism for that.

This also impacts the ARM/ARM64 code (which does not have
hotplug support yet).

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/cpu_hotplug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index cc6513a..5f80802 100644
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
+	/* PVH/ARM/ARM64 TBD/FIXME: future work */
+	if (!xen_pv_domain() || xen_feature(XENFEAT_auto_translated_physmap))
 		return -ENODEV;
 
 	register_xenstore_notifier(&xsn_cpu);
-- 
1.8.3.1

