Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbaFYPuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:50:05 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47551 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421AbaFYPuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:50:03 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        srinivas.kandagatla@linaro.com, linux-arm-kernel@lists.infradead.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com, patrice.chotard@st.com
Subject: [PATCH] pinctrl: st: add IRQCHIP_SKIP_SET_WAKE flag
Date: Wed, 25 Jun 2014 17:49:04 +0200
Message-Id: <1403711344-17335-1-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-25_05:2014-06-25,2014-06-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David PARIS <david.paris@st.com>

no .irq_set_wake API is available for pinctrl-st driver.
Add the IRQCHIP_SKIP_SET_WAKE flag to inform irq handler
not to call this API.

Signed-off-by: David Paris <david.paris@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index fb601fe..d881406 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1530,6 +1530,7 @@ static struct irq_chip st_gpio_irqchip = {
 	.irq_set_type	= st_gpio_irq_set_type,
 	.irq_startup	= st_gpio_irq_startup,
 	.irq_shutdown	= st_gpio_irq_shutdown,
+	.flags		= IRQCHIP_SKIP_SET_WAKE,
 };
 
 static int st_gpio_irq_domain_map(struct irq_domain *h,
-- 
1.9.1

