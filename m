Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3GOINA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:13:00 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:46758 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab3GOIM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:12:58 -0400
Date: Mon, 15 Jul 2013 10:14:26 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: pinctrl-single: fix compile warning when no
 CONFIG_PM
Message-ID: <20130715101426.4e4301b3@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning has been introduced by the commit
 0f9bc4bcdf4f pinctrl: single: adopt pinctrl sleep mode management

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/pinctrl/pinctrl-single.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 6866548..7323cca 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1483,6 +1483,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 	return ret;
 }
 
+#ifdef CONFIG_PM
 static int pinctrl_single_suspend(struct platform_device *pdev,
 					pm_message_t state)
 {
@@ -1505,6 +1506,7 @@ static int pinctrl_single_resume(struct platform_device *pdev)
 
 	return pinctrl_force_default(pcs->pctl);
 }
+#endif
 
 static int pcs_probe(struct platform_device *pdev)
 {

