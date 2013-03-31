Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3CaDOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 23:14:09 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:44293 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab3CaDOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 23:14:08 -0400
Message-ID: <1364699642.7876.1.camel@phoenix>
Subject: [PATCH 1/4] pwm: ab8500: Add .owner to struct pwm_ops
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arun R Murthy <arun.murthy@stericsson.com>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 11:14:02 +0800
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
 drivers/pwm/pwm-ab8500.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
index 3beb2b5..1d07a6f 100644
--- a/drivers/pwm/pwm-ab8500.c
+++ b/drivers/pwm/pwm-ab8500.c
@@ -88,6 +88,7 @@ static const struct pwm_ops ab8500_pwm_ops = {
 	.config = ab8500_pwm_config,
 	.enable = ab8500_pwm_enable,
 	.disable = ab8500_pwm_disable,
+	.owner = THIS_MODULE,
 };
 
 static int ab8500_pwm_probe(struct platform_device *pdev)
-- 
1.7.10.4



