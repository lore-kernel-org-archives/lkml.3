Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab3ENQxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:53:02 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64456 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610Ab3ENQw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:52:59 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hiroo MATSUMOTO <matsumoto.hiroo@jp.fujitsu.com>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [RFC PATCH v2, part 2 07/18] PCI, Microblaze: use hotplug-safe iterators to walk PCI buses
Date: Wed, 15 May 2013 00:51:51 +0800
Message-Id: <1368550322-1045-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance Microblaze architecture specific code to use hotplug-safe
iterators to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Hiroo MATSUMOTO <matsumoto.hiroo@jp.fujitsu.com>
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org
---
 arch/microblaze/pci/pci-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 9ea521e..14bd8e1 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1318,7 +1318,7 @@ void __init pcibios_resource_survey(void)
 	/* Allocate and assign resources. If we re-assign everything, then
 	 * we skip the allocate phase
 	 */
-	list_for_each_entry(b, &pci_root_buses, node)
+	for_each_pci_root_bus(b)
 		pcibios_allocate_bus_resources(b);
 
 	pcibios_allocate_resources(0);
@@ -1328,7 +1328,7 @@ void __init pcibios_resource_survey(void)
 	 * the low IO area and the VGA memory area if they intersect the
 	 * bus available resources to avoid allocating things on top of them
 	 */
-	list_for_each_entry(b, &pci_root_buses, node)
+	for_each_pci_root_bus(b)
 		pcibios_reserve_legacy_regions(b);
 
 	/* Now proceed to assigning things that were left unassigned */
-- 
1.8.1.2

