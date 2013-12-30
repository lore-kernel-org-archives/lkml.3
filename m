Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab3L3QJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:09:53 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43327 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3L3QJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:49 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/17] ARM: rpc: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:24 +0100
Message-Id: <1388419771-30075-10-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-rpc/dma.c  |    4 ++--
 arch/arm/mach-rpc/time.c |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-rpc/dma.c b/arch/arm/mach-rpc/dma.c
index 85883b2..80cc2c7 100644
--- a/arch/arm/mach-rpc/dma.c
+++ b/arch/arm/mach-rpc/dma.c
@@ -140,8 +140,8 @@ static int iomd_request_dma(unsigned int chan, dma_t *dma)
 {
 	struct iomd_dma *idma = container_of(dma, struct iomd_dma, dma);
 
-	return request_irq(idma->irq, iomd_dma_handle,
-			   IRQF_DISABLED, idma->dma.device_id, idma);
+	return request_irq(idma->irq, iomd_dma_handle, 0,
+			   idma->dma.device_id, idma);
 }
 
 static void iomd_free_dma(unsigned int chan, dma_t *dma)
diff --git a/arch/arm/mach-rpc/time.c b/arch/arm/mach-rpc/time.c
index 9a6def1..9a51588 100644
--- a/arch/arm/mach-rpc/time.c
+++ b/arch/arm/mach-rpc/time.c
@@ -75,7 +75,6 @@ ioc_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ioc_timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED,
 	.handler	= ioc_timer_interrupt
 };
 
-- 
1.7.9.5

