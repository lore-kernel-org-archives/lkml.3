Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3G2HiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:38:24 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59732 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab3G2HiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:38:22 -0400
From: Niels de Vos <ndevos@redhat.com>
To: devicetree@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, Niels de Vos <ndevos@redhat.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] imx2_wdt: expose module alias for loading from device-tree
Date: Mon, 29 Jul 2013 09:38:18 +0200
Message-Id: <1375083498-14822-1-git-send-email-ndevos@redhat.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable auto loading by udev when imx2_wdt is compiled as a module.

Signed-off-by: Niels de Vos <ndevos@redhat.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/watchdog/imx2_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 693ac3f..17680aa 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -322,6 +322,7 @@ static const struct of_device_id imx2_wdt_dt_ids[] = {
 	{ .compatible = "fsl,imx21-wdt", },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx2_wdt_dt_ids);
 
 static struct platform_driver imx2_wdt_driver = {
 	.remove		= __exit_p(imx2_wdt_remove),
-- 
1.7.11.7

