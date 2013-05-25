Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3EYNv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:51:58 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40357 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3EYNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:51:55 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3, part1 07/10] PCI, unicore, m68k: remove redundant call of pci_bus_add_devices()
Date: Sat, 25 May 2013 21:48:35 +0800
Message-Id: <1369489718-25869-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_scan_bus() and pci_scan_root_bus() has called pci_bus_add_devices()
once, so remove the redundant call of pci_bus_add_devices().
On the other handle, subsys_init() callbacks will be invoked before
device_init() callbacks, so it should be safe to remove the redundant
calls.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/m68k/platform/coldfire/pci.c | 2 +-
 arch/unicore32/kernel/pci.c       | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/m68k/platform/coldfire/pci.c b/arch/m68k/platform/coldfire/pci.c
index 8572246..2345972 100644
--- a/arch/m68k/platform/coldfire/pci.c
+++ b/arch/m68k/platform/coldfire/pci.c
@@ -320,7 +320,7 @@ static int __init mcf_pci_init(void)
 	pci_bus_size_bridges(rootbus);
 	pci_bus_assign_resources(rootbus);
 	pci_enable_bridges(rootbus);
-	pci_bus_add_devices(rootbus);
+
 	return 0;
 }
 
diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
index ef69c0c..374a055 100644
--- a/arch/unicore32/kernel/pci.c
+++ b/arch/unicore32/kernel/pci.c
@@ -277,11 +277,6 @@ static int __init pci_common_init(void)
 		pci_bus_assign_resources(puv3_bus);
 	}
 
-	/*
-	 * Tell drivers about devices found.
-	 */
-	pci_bus_add_devices(puv3_bus);
-
 	return 0;
 }
 subsys_initcall(pci_common_init);
-- 
1.8.1.2

