Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3CaDPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 23:15:21 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38146 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3CaDPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 23:15:20 -0400
Message-ID: <1364699715.7876.3.camel@phoenix>
Subject: [PATCH 2/4] pwm: atmel-tcb: Add .owner to struct pwm_ops
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Boris BREZILLON <linux-arm@overkiz.com>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 11:15:15 +0800
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
 drivers/pwm/pwm-atmel-tcb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 16cb530..0a7b658 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -358,6 +358,7 @@ static const struct pwm_ops atmel_tcb_pwm_ops = {
 	.set_polarity = atmel_tcb_pwm_set_polarity,
 	.enable = atmel_tcb_pwm_enable,
 	.disable = atmel_tcb_pwm_disable,
+	.owner = THIS_MODULE,
 };
 
 static int atmel_tcb_pwm_probe(struct platform_device *pdev)
-- 
1.7.10.4



