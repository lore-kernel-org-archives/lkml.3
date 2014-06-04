Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbaFEAle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:41:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaFDXVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 061/228] irqchip: armada-370-xp: Fix releasing of MSIs
Date: Wed,  4 Jun 2014 16:21:30 -0700
Message-Id: <20140604232350.018975031@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-armada-370-xp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -156,8 +156,10 @@ static void armada_370_xp_teardown_msi_i
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


