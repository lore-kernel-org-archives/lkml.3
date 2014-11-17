Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaKQJk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:40:58 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:43184 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaKQJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:40:52 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Liviu Dudau <liviu@dudau.co.uk>, <Suravee.Suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>
Subject: [RFC PATCH 09/16] PCI: Associate .get_msi_ctrl() with pci_host_bridge
Date: Mon, 17 Nov 2014 18:21:43 +0800
Message-ID: <1416219710-26088-10-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1416219710-26088-1-git-send-email-wangyijing@huawei.com>
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing0307@gmail.com>

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/host-bridge.c |    1 +
 include/linux/pci.h       |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 49b6c21..872cae1 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -58,6 +58,7 @@ struct pci_host_bridge *pci_create_host_bridge(
 	host->dev.parent = parent;
 	INIT_LIST_HEAD(&host->windows);
 	host->dev.release = pci_release_host_bridge_dev;
+	host->get_msi_ctrl = info->get_msi_ctrl;
 
 	/* this is hack, just for build, will be removed later*/
 	b = kzalloc(sizeof(*b), GFP_KERNEL);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a51f5f5..af1ee86 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -408,6 +408,7 @@ struct pci_host_bridge {
 	int domain;
 	void *sysdata;
 	struct pci_ops *ops;
+	struct msi_controller *(*get_msi_ctrl)(struct pci_dev *pdev);
 	void (*release_fn)(struct pci_host_bridge *);
 	void *release_data;
 };
@@ -416,6 +417,7 @@ struct pci_host_info {
 	u8 res_type;
 	void *arg;
 	struct list_head *resources; /*just for build, will clean up later */
+	struct msi_controller *(*get_msi_ctrl)(struct pci_dev *pdev);
 	int (*init_res)(struct pci_host_bridge *host, 
 			struct pci_host_info *info);
 };
-- 
1.7.1

