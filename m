Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3CaDRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 23:17:12 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:33700 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3CaDRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 23:17:10 -0400
Message-ID: <1364699825.7876.5.camel@phoenix>
Subject: [PATCH 4/4] pwm: twl: Add .owner to struct pwm_ops
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 11:17:05 +0800
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
 drivers/pwm/pwm-twl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
index bf3fda2..ee7fa5d 100644
--- a/drivers/pwm/pwm-twl.c
+++ b/drivers/pwm/pwm-twl.c
@@ -287,12 +287,14 @@ static const struct pwm_ops twl4030_pwm_ops = {
 	.disable = twl4030_pwm_disable,
 	.request = twl4030_pwm_request,
 	.free = twl4030_pwm_free,
+	.owner = THIS_MODULE,
 };
 
 static const struct pwm_ops twl6030_pwm_ops = {
 	.config = twl_pwm_config,
 	.enable = twl6030_pwm_enable,
 	.disable = twl6030_pwm_disable,
+	.owner = THIS_MODULE,
 };
 
 static int twl_pwm_probe(struct platform_device *pdev)
-- 
1.7.10.4



