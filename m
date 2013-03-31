Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3CaDQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 23:16:20 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:46215 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3CaDQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 23:16:19 -0400
Message-ID: <1364699774.7876.4.camel@phoenix>
Subject: [PATCH 3/4] pwm: twl-led: Add .owner to struct pwm_ops
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 11:16:14 +0800
In-Reply-To: <1364699642.7876.1.camel@phoenix>
References: <1364699642.7876.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing .owner of struct pwm_ops. This prevents the module from being
removed from underneath its users.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-twl-led.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pwm/pwm-twl-led.c b/drivers/pwm/pwm-twl-led.c
index 83e25d4..f912e87 100644
--- a/drivers/pwm/pwm-twl-led.c
+++ b/drivers/pwm/pwm-twl-led.c
@@ -271,6 +271,7 @@ static const struct pwm_ops twl4030_pwmled_ops = {
 	.enable = twl4030_pwmled_enable,
 	.disable = twl4030_pwmled_disable,
 	.config = twl4030_pwmled_config,
+	.owner = THIS_MODULE,
 };
 
 static const struct pwm_ops twl6030_pwmled_ops = {
@@ -279,6 +280,7 @@ static const struct pwm_ops twl6030_pwmled_ops = {
 	.config = twl6030_pwmled_config,
 	.request = twl6030_pwmled_request,
 	.free = twl6030_pwmled_free,
+	.owner = THIS_MODULE,
 };
 
 static int twl_pwmled_probe(struct platform_device *pdev)
-- 
1.7.10.4



