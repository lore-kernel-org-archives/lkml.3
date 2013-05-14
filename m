Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3ENQxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:53:07 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43391 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610Ab3ENQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:53:04 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [RFC PATCH v2, part 2 08/18] PCI, mn10300: use hotplug-safe iterators to walk PCI buses
Date: Wed, 15 May 2013 00:51:52 +0800
Message-Id: <1368550322-1045-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance mn10300 architecture specific code to use hotplug-safe
iterators to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/mn10300/unit-asb2305/pci-asb2305.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.c b/arch/mn10300/unit-asb2305/pci-asb2305.c
index c4e2e79..88c0c52 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -207,8 +207,11 @@ fs_initcall(pcibios_assign_resources);
 
 void __init pcibios_resource_survey(void)
 {
+	struct pci_bus *bus;
+
 	DBG("PCI: Allocating resources\n");
-	pcibios_allocate_bus_resources(&pci_root_buses);
+	for_each_pci_root_bus(bus)
+		pcibios_allocate_bus_resources(&bus->children);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
 }
-- 
1.8.1.2

