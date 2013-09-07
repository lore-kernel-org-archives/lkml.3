Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3IGJWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 05:22:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49913 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750872Ab3IGJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 05:22:46 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: monstr@monstr.eu
Cc: peter.crosthwaite@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] microblaze: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 11:22:43 +0200
Message-Id: <1378545763-8214-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from microblaze architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/microblaze/kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index aec5020..6f98815 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -162,7 +162,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction timer_irqaction = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_TIMER,
 	.name = "timer",
 	.dev_id = &clockevent_microblaze_timer,
 };
-- 
1.8.1.2

