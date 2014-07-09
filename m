Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaGIGHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:07:46 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51704 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaGIGHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:07:44 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: m.chehab@samsung.com, dan.carpenter@oracle.com, pavel@ucw.cz,
        gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Anil Belur <askb23@gmail.com>
Subject: [PATCH 2/2] staging: nokia_h4p: nokia_core.c - removed IRQF_DISABLED macro
Date: Wed,  9 Jul 2014 11:36:38 +0530
Message-Id: <1404885998-10981-2-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404885998-10981-1-git-send-email-askb23@gmail.com>
References: <1404885998-10981-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this patch removes the IRQF_DISABLED macro, as this is
  deprecated/noop.

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/nokia_h4p/nokia_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 5e19cd6..840cc66 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -1141,7 +1141,7 @@ static int hci_h4p_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, gpio_to_irq(info->host_wakeup_gpio),
 			  hci_h4p_wakeup_interrupt,  IRQF_TRIGGER_FALLING |
-			  IRQF_TRIGGER_RISING | IRQF_DISABLED,
+			  IRQF_TRIGGER_RISING,
 			  "hci_h4p_wkup", info);
 	if (err < 0) {
 		dev_err(info->dev, "hci_h4p: unable to get wakeup IRQ %d\n",
-- 
1.9.1

