Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaLIIfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:35:54 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42860 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbaLIIf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:35:27 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl: st: Add irq_disable hook to st_gpio_irqchip
Date: Tue,  9 Dec 2014 09:35:15 +0100
Message-Id: <1418114115-26064-3-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418114115-26064-1-git-send-email-patrice.chotard@st.com>
References: <1418114115-26064-1-git-send-email-patrice.chotard@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-09_03:2014-12-08,2014-12-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dev <pankaj.dev@st.com>

Currently disable_irq() doesn't work for pinctrl-st driver, due to
missing irq_disable hook in the driver.
disable_irq() is required only for level-triggered interrupts, which
is not the case normally.

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 2870a68..217259b 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1445,6 +1445,7 @@ static struct gpio_chip st_gpio_template = {
 
 static struct irq_chip st_gpio_irqchip = {
 	.name		= "GPIO",
+	.irq_disable    = st_gpio_irq_mask,
 	.irq_mask	= st_gpio_irq_mask,
 	.irq_unmask	= st_gpio_irq_unmask,
 	.irq_set_type	= st_gpio_irq_set_type,
-- 
1.9.1

