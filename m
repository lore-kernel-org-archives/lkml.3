Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaJAUd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:33:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37720 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbaJAUdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:33:55 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: gregkh@linuxfoundation.org
Cc: gulsah.1004@gmail.com, pavel@ucw.cz, kristina.martsenko@gmail.com,
        cmroliv@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] staging: nokia_h4: remove deprecated IRQF_DISABLED
Date: Wed,  1 Oct 2014 22:33:48 +0200
Message-Id: <1412195628-9522-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of the IRQF_DISABLED flag
from drivers/staging/nokia_h4p/nokia_core.c

It's a NOOP since 2.6.35 and it will be removed soon.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/staging/nokia_h4p/nokia_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 775e1d043230..61bc204eedae 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -1133,7 +1133,7 @@ static int hci_h4p_probe(struct platform_device *pdev)
 	info->uart_fclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_fclk);
 
 	err = devm_request_irq(&pdev->dev, info->irq, hci_h4p_interrupt,
-				IRQF_DISABLED, "hci_h4p", info);
+				0, "hci_h4p", info);
 	if (err < 0) {
 		dev_err(info->dev, "hci_h4p: unable to get IRQ %d\n",
 			info->irq);
@@ -1142,8 +1142,7 @@ static int hci_h4p_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, gpio_to_irq(info->host_wakeup_gpio),
 			  hci_h4p_wakeup_interrupt,  IRQF_TRIGGER_FALLING |
-			  IRQF_TRIGGER_RISING | IRQF_DISABLED,
-			  "hci_h4p_wkup", info);
+			  IRQF_TRIGGER_RISING, "hci_h4p_wkup", info);
 	if (err < 0) {
 		dev_err(info->dev, "hci_h4p: unable to get wakeup IRQ %d\n",
 			  gpio_to_irq(info->host_wakeup_gpio));
-- 
1.9.1

