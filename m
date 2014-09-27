Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaI0Gbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 02:31:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38278 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751532AbaI0Gbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 02:31:32 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: ralf@linux-mips.org, akpm@linux-foundation.org
Cc: jkosina@suse.cz, standby24x7@gmail.com, rdunlap@infradead.org,
        yongjun_wei@trendmicro.com.cn, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MIPS: ralink: remove deprecated IRQF_DISABLED
Date: Sat, 27 Sep 2014 08:31:05 +0200
Message-Id: <1411799465-18508-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of the IRQF_DISABLED flag
from arch/mips/ralink/timer.c

It's a NOOP since 2.6.35 and it will be removed soon.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/mips/ralink/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/ralink/timer.c b/arch/mips/ralink/timer.c
index e38692a44e69..5bb29b3790ff 100644
--- a/arch/mips/ralink/timer.c
+++ b/arch/mips/ralink/timer.c
@@ -58,7 +58,7 @@ static irqreturn_t rt_timer_irq(int irq, void *_rt)
 
 static int rt_timer_request(struct rt_timer *rt)
 {
-	int err = request_irq(rt->irq, rt_timer_irq, IRQF_DISABLED,
+	int err = request_irq(rt->irq, rt_timer_irq, 0,
 						dev_name(rt->dev), rt);
 	if (err) {
 		dev_err(rt->dev, "failed to request irq\n");
-- 
1.9.1

