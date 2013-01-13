Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3AMX1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:27:47 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33157 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3AMX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:27:45 -0500
Subject: [PATCH v7 2/4] PCI: shpchp: Make shpchp_wq non-ordered
To: Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Daniel J Blueman <daniel@quora.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Date: Sun, 13 Jan 2013 16:27:43 -0700
Message-ID: <20130113232743.7225.11180.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20130113232606.7225.94802.stgit@bhelgaas.mtv.corp.google.com>
References: <20130113232606.7225.94802.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e24dcbef93 ("shpchp: update workqueue usage") was described as adding
non-ordered shpchp_wq, but it actually made it an *ordered* workqueue.

This patch changes shpchp_wq to be non-ordered, as described in the
e24dcbef93 commit log and as was done for pciehp by a827ea307b ("pciehp:
update workqueue usage").

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Tejun Heo <tj@kernel.org>
---
 drivers/pci/hotplug/shpchp_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index b6de307..59ca86c 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -366,7 +366,7 @@ static int __init shpcd_init(void)
 {
 	int retval = 0;
 
-	shpchp_wq = alloc_ordered_workqueue("shpchp", 0);
+	shpchp_wq = alloc_workqueue("shpchp", 0, 0);
 	if (!shpchp_wq)
 		return -ENOMEM;
 

