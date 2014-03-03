Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaCCTwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:52:02 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33313 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbaCCTvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:51:55 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 3/5] irqchip: gic: parse IRQ specifier flag src/dst inversion
Date: Mon,  3 Mar 2014 12:51:38 -0700
Message-Id: <1393876300-3061-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Modify the GIC driver to parse IRQ specifier flag bit 4 (src/dst
inverted) in the xlate function.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v3: New patch.
---
 drivers/irqchip/irq-gic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 500e533b9648..97800b349f54 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -847,6 +847,9 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 		*out_hwirq += 16;
 
 	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
+	if (intspec[2] & BIT(4))
+		*out_type |= IRQ_SRC_DST_INVERTED;
+
 	return 0;
 }
 
-- 
1.8.1.5

