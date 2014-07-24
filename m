Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbaGXJrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:47:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbaGXJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 057/128] irqchip: spear_shirq: Fix interrupt offset
Date: Thu, 24 Jul 2014 10:45:06 +0100
Message-Id: <1406195177-8656-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 4f4366033945419b0c52118c29d3057d7c558765 upstream.

The ras3 block on spear320 claims to have 3 interrupts. In fact it has
one and 6 reserved interrupts. Account the 6 reserved to this block so
it has 7 interrupts total. That matches the datasheet and the device
tree entries.

Broken since commit 80515a5a(ARM: SPEAr3xx: shirq: simplify and move
the shared irq multiplexor to DT). Testing is overrated....

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20140619212712.872379208@linutronix.de
Fixes: 80515a5a2e3c ('ARM: SPEAr3xx: shirq: simplify and move the shared irq multiplexor to DT')
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/spear-shirq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/spear-shirq.c b/drivers/irqchip/spear-shirq.c
index 8527743b5cef..391b9cea73ed 100644
--- a/drivers/irqchip/spear-shirq.c
+++ b/drivers/irqchip/spear-shirq.c
@@ -125,7 +125,7 @@ static struct spear_shirq spear320_shirq_ras2 = {
 };
 
 static struct spear_shirq spear320_shirq_ras3 = {
-	.irq_nr = 3,
+	.irq_nr = 7,
 	.irq_bit_off = 0,
 	.invalid_irq = 1,
 	.regs = {
-- 
1.9.1

