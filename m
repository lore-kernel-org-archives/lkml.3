Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3CZUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3CZUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:09:57 -0400
Date: Tue, 26 Mar 2013 13:08:44 -0700
From: tip-bot for Abhijeet Dharmapurikar <tipbot@zytor.com>
Message-ID: <tip-bad9a43a20372a3b41e15e8aa03b918c76f360f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        adharmap@codeaurora.org, tglx@linutronix.de, sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adharmap@codeaurora.org, tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1363734349-32635-1-git-send-email-sboyd@codeaurora.org>
References: <1363734349-32635-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irqchip: gic: fix irq_trigger return
Git-Commit-ID: bad9a43a20372a3b41e15e8aa03b918c76f360f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 26 Mar 2013 13:08:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bad9a43a20372a3b41e15e8aa03b918c76f360f0
Gitweb:     http://git.kernel.org/tip/bad9a43a20372a3b41e15e8aa03b918c76f360f0
Author:     Abhijeet Dharmapurikar <adharmap@codeaurora.org>
AuthorDate: Tue, 19 Mar 2013 16:05:49 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 26 Mar 2013 20:52:25 +0100

irqchip: gic: fix irq_trigger return

The genirq layer expects a 0 in case that the retrigger function is
not able to resend the irq in hardware, but the code is returning
-ENXIO. Fix it.

[ tglx: Reworked comment and changelog ]

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1363734349-32635-1-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-gic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index a32e0d5..fc6aebf 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -236,7 +236,8 @@ static int gic_retrigger(struct irq_data *d)
 	if (gic_arch_extn.irq_retrigger)
 		return gic_arch_extn.irq_retrigger(d);
 
-	return -ENXIO;
+	/* the genirq layer expects 0 if we can't retrigger in hardware */
+	return 0;
 }
 
 #ifdef CONFIG_SMP
