Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaJAKFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:05:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33276 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751105AbaJAKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:05:07 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: liqin.linux@gmail.com, lennox.wu@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] score: remove deprecated IRQF_DISABLED
Date: Wed,  1 Oct 2014 12:04:58 +0200
Message-Id: <1412157898-7040-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <CAF0htA4B=jhBu_YmSTj9=BQ-m3_UGRggwop5ZtgPbO9Y45V+aA@mail.gmail.com>
References: <CAF0htA4B=jhBu_YmSTj9=BQ-m3_UGRggwop5ZtgPbO9Y45V+aA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the use of the IRQF_DISABLED flag
from arch/score/kernel/time.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
index f0a43affb201..24770cd9b473 100644
--- a/arch/score/kernel/time.c
+++ b/arch/score/kernel/time.c
@@ -41,7 +41,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction timer_irq = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_TIMER,
 	.name = "timer",
 };
 
-- 
1.9.1

