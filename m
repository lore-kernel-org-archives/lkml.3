Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858Ab3CZOzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:55:08 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:46964 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab3CZOzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:55:04 -0400
Message-ID: <1364309698.4090.1.camel@phoenix>
Subject: [PATCH 1/2] pwm: tiecap: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Philip Avinash <avinashphilip@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 22:54:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both ecap_pwm_save_context() and ecap_pwm_restore_context() are only used in
this file, make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-tiecap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index f024db0..0d65fb2 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -295,7 +295,7 @@ static int ecap_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&pc->chip);
 }
 
-void ecap_pwm_save_context(struct ecap_pwm_chip *pc)
+static void ecap_pwm_save_context(struct ecap_pwm_chip *pc)
 {
 	pm_runtime_get_sync(pc->chip.dev);
 	pc->ctx.ecctl2 = readw(pc->mmio_base + ECCTL2);
@@ -304,7 +304,7 @@ void ecap_pwm_save_context(struct ecap_pwm_chip *pc)
 	pm_runtime_put_sync(pc->chip.dev);
 }
 
-void ecap_pwm_restore_context(struct ecap_pwm_chip *pc)
+static void ecap_pwm_restore_context(struct ecap_pwm_chip *pc)
 {
 	writel(pc->ctx.cap3, pc->mmio_base + CAP3);
 	writel(pc->ctx.cap4, pc->mmio_base + CAP4);
-- 
1.7.10.4



