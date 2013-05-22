Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3EVGjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:39:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47899 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab3EVGjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:39:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 1/8] PCI: Don't use temp bus for pci_bus_release_bridge_resources
Date: Tue, 21 May 2013 23:38:41 -0700
Message-Id: <1369204728-11165-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
References: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as later bus can not be used as temp variable after we change to
per root bus handling with assign unassigned resources.

Per Bjorn, separated out different patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1458,12 +1458,11 @@ again:
 	 * Try to release leaf bridge's resources that doesn't fit resource of
 	 * child device under that bridge
 	 */
-	list_for_each_entry(fail_res, &fail_head, list) {
-		bus = fail_res->dev->bus;
-		pci_bus_release_bridge_resources(bus,
+	list_for_each_entry(fail_res, &fail_head, list)
+		pci_bus_release_bridge_resources(fail_res->dev->bus,
 						 fail_res->flags & type_mask,
 						 rel_type);
-	}
+
 	/* restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
 		struct resource *res = fail_res->res;
