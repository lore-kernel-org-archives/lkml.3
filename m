Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3EZP67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:58:59 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56799 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3EZP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:58:56 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH v3, part2 14/20] PCI, DRM: use hotplug-safe iterators to walk PCI buses
Date: Sun, 26 May 2013 23:53:11 +0800
Message-Id: <1369583597-3801-15-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance DRM drvier to use hotplug-safe iterators to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/drm_fops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 429e07d..dc8c40b 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -359,9 +359,11 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
 			pci_dev_put(pci_dev);
 		}
 		if (!dev->hose) {
-			struct pci_bus *b = pci_bus_b(pci_root_buses.next);
-			if (b)
+			struct pci_bus *b = pci_get_next_root_bus(NULL);
+			if (b) {
 				dev->hose = b->sysdata;
+				pci_bus_put(b);
+			}
 		}
 	}
 #endif
-- 
1.8.1.2

