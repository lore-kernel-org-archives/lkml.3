Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3LIFC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:02:57 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32773 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364Ab3LIFC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:02:56 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: eric.y.miao@gmail.com, haojian.zhuang@gmail.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: mmp: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 06:02:46 +0100
Message-Id: <1386565366-19286-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381548299-5093-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381548299-5093-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-mmp/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 7ac41e83cfef..6aacc9b050f5 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -186,7 +186,7 @@ static void __init timer_config(void)
 
 static struct irqaction timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= timer_interrupt,
 	.dev_id		= &ckevt,
 };
-- 
1.8.3.2

