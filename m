Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaKXUXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:23:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaKXUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:23:46 -0500
Date: Sun, 23 Nov 2014 10:09:53 -0800
From: tip-bot for Yingjoe Chen <tipbot@zytor.com>
Message-ID: <tip-56e8abab615e0c5858cfb9fa0015a44641762b9d@git.kernel.org>
Cc: yingjoe.chen@mediatek.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        hc.yen@mediatek.com, mingo@kernel.org, jason@lakedaemon.net,
        eddie.huang@mediatek.com, yingjoe.chen@gmail.com, mark.rutland@arm.com,
        tglx@linutronix.de, srv_heupstream@mediatek.com,
        nathan.chung@mediatek.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        wangyijing@huawei.com, yh.chen@mediatek.com, bhelgaas@google.com,
        pawel.moll@arm.com, matthias.bgg@gmail.com, jiang.liu@linux.intel.com,
        hpa@zytor.com, linux@arm.linux.org.uk,
        boris.brezillon@free-electrons.com
Reply-To: yingjoe.chen@gmail.com, eddie.huang@mediatek.com,
        jason@lakedaemon.net, tglx@linutronix.de, mark.rutland@arm.com,
        marc.zyngier@arm.com, yingjoe.chen@mediatek.com, hc.yen@mediatek.com,
        mingo@kernel.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, jiang.liu@linux.intel.com,
        matthias.bgg@gmail.com, pawel.moll@arm.com,
        boris.brezillon@free-electrons.com, linux@arm.linux.org.uk,
        hpa@zytor.com, grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, srv_heupstream@mediatek.com,
        nathan.chung@mediatek.com, bhelgaas@google.com, yh.chen@mediatek.com,
        wangyijing@huawei.com
In-Reply-To: <1415893029-2971-3-git-send-email-yingjoe.chen@mediatek.com>
References: <1415893029-2971-3-git-send-email-yingjoe.chen@mediatek.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/irqdomain] genirq:
  Add more helper functions to support stacked irq_chip
Git-Commit-ID: 56e8abab615e0c5858cfb9fa0015a44641762b9d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56e8abab615e0c5858cfb9fa0015a44641762b9d
Gitweb:     http://git.kernel.org/tip/56e8abab615e0c5858cfb9fa0015a44641762b9d
Author:     Yingjoe Chen <yingjoe.chen@mediatek.com>
AuthorDate: Thu, 13 Nov 2014 23:37:05 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 23 Nov 2014 13:01:46 +0100

genirq: Add more helper functions to support stacked irq_chip

Add more helper function for stacked irq_chip to just call parent's
function.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Gran Likely <grant.likely@linaro.org>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: <linux-arm-kernel@lists.infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: <srv_heupstream@mediatek.com>
Cc: <yingjoe.chen@gmail.com>
Cc: <hc.yen@mediatek.com>
Cc: <eddie.huang@mediatek.com>
Cc: <nathan.chung@mediatek.com>
Cc: <yh.chen@mediatek.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Link: http://lkml.kernel.org/r/1415893029-2971-3-git-send-email-yingjoe.chen@mediatek.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |  6 ++++++
 kernel/irq/chip.c   | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 0adcbbb..fad4bf6 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -446,6 +446,12 @@ extern void handle_nested_irq(unsigned int irq);
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
 extern void irq_chip_ack_parent(struct irq_data *data);
 extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
+extern void irq_chip_mask_parent(struct irq_data *data);
+extern void irq_chip_unmask_parent(struct irq_data *data);
+extern void irq_chip_eoi_parent(struct irq_data *data);
+extern int irq_chip_set_affinity_parent(struct irq_data *data,
+					const struct cpumask *dest,
+					bool force);
 #endif
 
 /* Handling of unhandled and spurious interrupts: */
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dd1d3c4..47f4c64 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -863,6 +863,54 @@ void irq_chip_ack_parent(struct irq_data *data)
 }
 
 /**
+ * irq_chip_mask_parent - Mask the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ */
+void irq_chip_mask_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_mask(data);
+}
+
+/**
+ * irq_chip_unmask_parent - Unmask the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ */
+void irq_chip_unmask_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_unmask(data);
+}
+
+/**
+ * irq_chip_eoi_parent - Invoke EOI on the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ */
+void irq_chip_eoi_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_eoi(data);
+}
+
+/**
+ * irq_chip_set_affinity_parent - Set affinity on the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ * @dest:	The affinity mask to set
+ * @force:	Flag to enforce setting (disable online checks)
+ *
+ * Conditinal, as the underlying parent chip might not implement it.
+ */
+int irq_chip_set_affinity_parent(struct irq_data *data,
+				 const struct cpumask *dest, bool force)
+{
+	data = data->parent_data;
+	if (data->chip->irq_set_affinity)
+		return data->chip->irq_set_affinity(data, dest, force);
+
+	return -ENOSYS;
+}
+
+/**
  * irq_chip_retrigger_hierarchy - Retrigger an interrupt in hardware
  * @data:	Pointer to interrupt specific data
  *
