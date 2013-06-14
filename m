Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3FNNSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:18:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51154 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3FNNSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:18:32 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, <kishon@ti.com>
Subject: [PATCH] extcon: palmas: remove assigning "edev.name" to palmas
Date: Fri, 14 Jun 2013 18:48:24 +0530
Message-ID: <1371215904-2189-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_extcon_get_extcon_dev() uses dev_name for getting the reference
to the extcon device. If the extcon driver assigns a different
name other than dev_name, of_extcon_get_extcon_dev() wouldn't
be able to find the reference to the extcon device. Since the
client drivers of extcon-palmas would be using
of_extcon_get_extcon_dev(), removed assigning edev.name
in extcon-palmas.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/extcon/extcon-palmas.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index b752a0a..7350ac2 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -172,7 +172,6 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, palmas_usb);
 
-	palmas_usb->edev.name = "palmas-usb";
 	palmas_usb->edev.supported_cable = palmas_extcon_cable;
 	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
 
-- 
1.7.10.4

