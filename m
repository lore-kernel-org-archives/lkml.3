Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab3CZO4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:56:06 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33360 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786Ab3CZO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:56:04 -0400
Message-ID: <1364309757.4090.2.camel@phoenix>
Subject: [PATCH 2/2] pwm: tiehrpwm: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Philip Avinash <avinashphilip@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 22:55:57 +0800
In-Reply-To: <1364309698.4090.1.camel@phoenix>
References: <1364309698.4090.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both ehrpwm_pwm_save_context() and ehrpwm_pwm_restore_context() are only used in
this file, make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-tiehrpwm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index d058ba9..6a21759 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -533,7 +533,7 @@ static int ehrpwm_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&pc->chip);
 }
 
-void ehrpwm_pwm_save_context(struct ehrpwm_pwm_chip *pc)
+static void ehrpwm_pwm_save_context(struct ehrpwm_pwm_chip *pc)
 {
 	pm_runtime_get_sync(pc->chip.dev);
 	pc->ctx.tbctl = ehrpwm_read(pc->mmio_base, TBCTL);
@@ -547,7 +547,7 @@ void ehrpwm_pwm_save_context(struct ehrpwm_pwm_chip *pc)
 	pm_runtime_put_sync(pc->chip.dev);
 }
 
-void ehrpwm_pwm_restore_context(struct ehrpwm_pwm_chip *pc)
+static void ehrpwm_pwm_restore_context(struct ehrpwm_pwm_chip *pc)
 {
 	ehrpwm_write(pc->mmio_base, TBPRD, pc->ctx.tbprd);
 	ehrpwm_write(pc->mmio_base, CMPA, pc->ctx.cmpa);
-- 
1.7.10.4



