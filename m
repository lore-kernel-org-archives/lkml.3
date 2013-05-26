Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3EZP7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:59:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61197 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3EZP7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:59:02 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: [PATCH v3, part2 15/20] PCI, EDAC: use hotplug-safe PCI bus iterators to walk PCI buses
Date: Sun, 26 May 2013 23:53:12 +0800
Message-Id: <1369583597-3801-16-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance EDAC drviers to use hotplug-safe iterators to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/edac/i7core_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 0ec3e95..7146e10 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1296,7 +1296,7 @@ static unsigned i7core_pci_lastbus(void)
 	int last_bus = 0, bus;
 	struct pci_bus *b = NULL;
 
-	while ((b = pci_find_next_bus(b)) != NULL) {
+	for_each_pci_root_bus(b) {
 		bus = b->number;
 		edac_dbg(0, "Found bus %d\n", bus);
 		if (bus > last_bus)
-- 
1.8.1.2

