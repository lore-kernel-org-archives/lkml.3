Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaFJTvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:51:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35220 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaFJTu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Greatorex <neil@fatboyfat.co.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 102/160] irqchip: armada-370-xp: Fix releasing of MSIs
Date: Tue, 10 Jun 2014 12:45:42 -0700
Message-Id: <1402429600-20477-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Greatorex <neil@fatboyfat.co.uk>

commit ff3c664505bf8a8334bca5045e87b85cfe4d2277 upstream.

Store the value of d->hwirq in a local variable as the real value is wiped out
by calling irq_dispose_mapping. Without this patch, the armada_370_xp_free_msi
function would always free MSI#0, no matter what was passed to it.

Fixes: 31f614edb726fcc4d5aa0f2895fbdec9b04a3ca4 ('irqchip: armada-370-xp: implement MSI support')
Signed-off-by: Neil Greatorex <neil@fatboyfat.co.uk>
Link: https://lkml.kernel.org/r/1397823593-1932-4-git-send-email-thomas.petazzoni@free-electrons.com
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397823593-1932-4-git-send-email-thomas.petazzoni@free-electrons.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/irqchip/irq-armada-370-xp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 6cb87c4..d9cd6df 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -158,8 +158,10 @@ static void armada_370_xp_teardown_msi_irq(struct msi_chip *chip,
 					   unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
+	unsigned long hwirq = d->hwirq;
+
 	irq_dispose_mapping(irq);
-	armada_370_xp_free_msi(d->hwirq);
+	armada_370_xp_free_msi(hwirq);
 }
 
 static int armada_370_xp_check_msi_device(struct msi_chip *chip, struct pci_dev *dev,
-- 
1.9.1

