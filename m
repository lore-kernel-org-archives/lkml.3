Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3BAMKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:10:06 -0500
Received: from nbd.name ([46.4.11.11]:41391 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab3BAMH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:07:58 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>
Subject: [PATCH 06/11] PINCTRL: lantiq: only probe available pad controllers
Date: Fri,  1 Feb 2013 13:05:00 +0100
Message-Id: <1359720305-31933-6-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The template falcon.dtsi lists all 6 pad controllers that can be loaded. Only
probe those that have status = "okay"; inside the dts file.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-falcon.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index 8ed20e8..6331c5c 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -398,6 +398,9 @@ static int pinctrl_falcon_probe(struct platform_device *pdev)
 		u32 avail;
 		int pins;
 
+		if (!of_device_is_available(np))
+			continue;
+
 		if (!ppdev) {
 			dev_err(&pdev->dev, "failed to find pad pdev\n");
 			continue;
-- 
1.7.10.4

