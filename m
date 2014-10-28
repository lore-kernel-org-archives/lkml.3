Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaJ1Djn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:39:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaJ1Djf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:39:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.17 094/146] PCI: Add missing MEM_64 mask in pci_assign_unassigned_bridge_resources()
Date: Tue, 28 Oct 2014 11:33:56 +0800
Message-Id: <20141028033347.511578463@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit d61b0e87d2dfba3706dbbd6c7c6fd41c3d845685 upstream.

In 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to
64-bit resources"), we added IORESOURCE_MEM_64 to the mask in
pci_assign_unassigned_root_bus_resources(), but not to the mask in
pci_assign_unassigned_bridge_resources().

Add IORESOURCE_MEM_64 to the pci_assign_unassigned_bridge_resources() type
mask.

Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1652,7 +1652,7 @@ void pci_assign_unassigned_bridge_resour
 	struct pci_dev_resource *fail_res;
 	int retval;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
-				  IORESOURCE_PREFETCH;
+				  IORESOURCE_PREFETCH | IORESOURCE_MEM_64;
 
 again:
 	__pci_bus_size_bridges(parent, &add_list);


