Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaCDQlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:41:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaCDQlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:41:03 -0500
Date: Tue, 4 Mar 2014 08:40:17 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-f7bfca6db60a6ca0a73126918b2fb6f851065947@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jg1.han@samsung.com, bhelgaas@google.com,
        mohit.kumar@st.com, tglx@linutronix.de, linux-pci@vger.kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, jg1.han@samsung.com, bhelgaas@google.com,
        mohit.kumar@st.com, tglx@linutronix.de, linux-pci@vger.kernel.org
In-Reply-To: <20140223212736.987803648@linutronix.de>
References: <20140223212736.987803648@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] pci: pcie-designware: Remove irq_desc abuse
Git-Commit-ID: f7bfca6db60a6ca0a73126918b2fb6f851065947
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

Commit-ID:  f7bfca6db60a6ca0a73126918b2fb6f851065947
Gitweb:     http://git.kernel.org/tip/f7bfca6db60a6ca0a73126918b2fb6f851065947
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:11 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:52 +0100

pci: pcie-designware: Remove irq_desc abuse

There is no reason to care about irq_desc in that context, escpecially
as irq_data for that interrupt is retrieved as well.

Use the proper accessor for the msi descriptor

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
Cc: pci <linux-pci@vger.kernel.org>
Link: http://lkml.kernel.org/r/20140223212736.987803648@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/host/pcie-designware.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 17ce88f..2e48ecf 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -294,14 +294,12 @@ no_valid_irq:
 static void clear_irq(unsigned int irq)
 {
 	unsigned int pos, nvec;
-	struct irq_desc *desc;
 	struct msi_desc *msi;
 	struct pcie_port *pp;
 	struct irq_data *data = irq_get_irq_data(irq);
 
 	/* get the port structure */
-	desc = irq_to_desc(irq);
-	msi = irq_desc_get_msi_desc(desc);
+	msi = irq_data_get_msi(data);
 	pp = sys_to_pcie(msi->dev->bus->sysdata);
 	if (!pp) {
 		BUG();
