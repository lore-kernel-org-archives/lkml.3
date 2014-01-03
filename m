Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaACUaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:30:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23349 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbaACUaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 18/19] xen/pvh: Piggyback on PVHVM XenBus.
Date: Fri,  3 Jan 2014 14:38:35 -0500
Message-Id: <1388777916-1328-19-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

PVH is a PV guest with a twist - there are certain things
that work in it like HVM and some like PV. For the XenBus
mechanism we want to use the PVHVM mechanism.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/xenbus/xenbus_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index ec097d6..01d59e6 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -45,6 +45,7 @@
 #include <xen/grant_table.h>
 #include <xen/xenbus.h>
 #include <xen/xen.h>
+#include <xen/features.h>
 
 #include "xenbus_probe.h"
 
@@ -743,7 +744,7 @@ static const struct xenbus_ring_ops ring_ops_hvm = {
 
 void __init xenbus_ring_ops_init(void)
 {
-	if (xen_pv_domain())
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
 		ring_ops = &ring_ops_pv;
 	else
 		ring_ops = &ring_ops_hvm;
-- 
1.8.3.1

