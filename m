Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3IXClC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 22:41:02 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:61414 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3IXClA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 22:41:00 -0400
MIME-Version: 1.0
Date: Tue, 24 Sep 2013 10:40:57 +0800
Message-ID: <CAPgLHd-C0o3QsJ0TBfn4aE1foWFrwjUy3iSJCkAhgZrfs=e5CQ@mail.gmail.com>
Subject: [PATCH] mmc: cb710: drop free_irq for devm_request_irq allocated irq
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mirq-linux@rere.qmqm.pl, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

irq allocated with devm_request_irq should not be freed using
free_irq, because doing so causes a dangling pointer, and a
subsequent double free.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/cb710/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/cb710/core.c b/drivers/misc/cb710/core.c
index 2e50f81..fb397e7 100644
--- a/drivers/misc/cb710/core.c
+++ b/drivers/misc/cb710/core.c
@@ -176,7 +176,7 @@ static int cb710_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct cb710_chip *chip = pci_get_drvdata(pdev);
 
-	free_irq(pdev->irq, chip);
+	devm_free_irq(&pdev->dev, pdev->irq, chip);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	if (state.event & PM_EVENT_SLEEP)

