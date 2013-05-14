Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab3ENQx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:53:57 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:57670 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab3ENQxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:53:54 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [RFC PATCH v2, part 2 17/18] PCI, eeepc-laptop: use hotplug-safe iterators to walk PCI buses
Date: Wed, 15 May 2013 00:52:01 +0800
Message-Id: <1368550322-1045-17-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance eeepc-laptop drvier to use hotplug-safe iterators to walk
PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: acpi4asus-user@lists.sourceforge.net
Cc: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/platform/x86/eeepc-laptop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 5d26e70..6291b4f 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -759,7 +759,7 @@ static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
 static int eeepc_setup_pci_hotplug(struct eeepc_laptop *eeepc)
 {
 	int ret = -ENOMEM;
-	struct pci_bus *bus = pci_find_bus(0, 1);
+	struct pci_bus *bus = pci_get_bus(0, 1);
 
 	if (!bus) {
 		pr_err("Unable to find wifi PCI bus\n");
@@ -787,6 +787,8 @@ static int eeepc_setup_pci_hotplug(struct eeepc_laptop *eeepc)
 		goto error_register;
 	}
 
+	pci_bus_put(bus);
+
 	return 0;
 
 error_register:
@@ -795,6 +797,7 @@ error_info:
 	kfree(eeepc->hotplug_slot);
 	eeepc->hotplug_slot = NULL;
 error_slot:
+	pci_bus_put(bus);
 	return ret;
 }
 
-- 
1.8.1.2

