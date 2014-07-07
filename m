Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaGGXyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbaGGXyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 75/94] irqchip: spear_shirq: Fix interrupt offset
Date: Mon,  7 Jul 2014 16:58:05 -0700
Message-Id: <20140707235758.992140089@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/spear-shirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/spear-shirq.c
+++ b/drivers/irqchip/spear-shirq.c
@@ -125,7 +125,7 @@ static struct spear_shirq spear320_shirq
 };
 
 static struct spear_shirq spear320_shirq_ras3 = {
-	.irq_nr = 3,
+	.irq_nr = 7,
 	.irq_bit_off = 0,
 	.invalid_irq = 1,
 	.regs = {


