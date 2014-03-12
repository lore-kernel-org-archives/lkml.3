Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaCLONf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:13:35 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:45374 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbaCLONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:13:31 -0400
X-Greylist: delayed 1897 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2014 10:13:31 EDT
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: <kernel@stlinux.com>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH] pinctrl: st: Fix error check for of_irq_to_resource usage
Date: Wed, 12 Mar 2014 13:35:05 +0000
Message-ID: <1394631305-4083-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-12_05:2014-03-12,2014-03-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch fixes an error check while using of_irq_to_resource.
of_irq_to_resource returns non-zero interrupt number on success and zero
on error. The driver was using error check is wrong way.

Without this patch the driver will configure interrupt zero if there is
no interrupt specified in the node.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/pinctrl/pinctrl-st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 51e4f3a..19b8f91 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1426,7 +1426,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 	 *	[irqN]----> [gpio-bank (n)]
 	 */
 
-	if (!of_irq_to_resource(np, 0, &irq_res)) {
+	if (of_irq_to_resource(np, 0, &irq_res)) {
 		gpio_irq = irq_res.start;
 		irq_set_chained_handler(gpio_irq, st_gpio_irq_handler);
 		irq_set_handler_data(gpio_irq, bank);
-- 
1.7.9.5

