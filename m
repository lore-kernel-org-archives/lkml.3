Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaJAQsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbaJAQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:48:40 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3/3] Revert "PCI/MSI: Remove unused get_cached_msi_msg()"
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com
Date: Wed, 01 Oct 2014 10:48:34 -0600
Message-ID: <20141001164834.2709.98003.stgit@gimli.home>
In-Reply-To: <20141001163814.2709.92885.stgit@gimli.home>
References: <20141001163814.2709.92885.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have an upcoming merge collision with code that actually does use
this, b8f02af096b1fc9fd46680cbe55214e477eb76d3.  Restore this function
in advance of the merge.

This reverts a160fe94cb533a438258642d8d5b2b3795497341

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/msi.c   |    7 +++++++
 include/linux/msi.h |    1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 2bd0fbe..12fdb27 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -289,6 +289,13 @@ void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 	*msg = entry->msg;
 }
 
+void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct msi_desc *entry = irq_get_msi_desc(irq);
+
+	__get_cached_msi_msg(entry, msg);
+}
+
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	if (entry->dev->current_state != PCI_D0) {
diff --git a/include/linux/msi.h b/include/linux/msi.h
index d0e0cfe..fb35a71 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -18,6 +18,7 @@ void unmask_msi_irq(struct irq_data *data);
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
 void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
 struct msi_desc {

