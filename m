Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834Ab3IXESv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:18:51 -0400
Received: from gw.cm.dream.jp ([59.157.128.2]:32120 "EHLO vsmtp02.cm.dti.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750706Ab3IXESt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:18:49 -0400
Date: Tue, 24 Sep 2013 13:09:24 +0900
From: takasi-y@ops.dti.ne.jp
To: SH-Linux <linux-sh@vger.kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] clocksource: em_sti: convert to clk_prepare/unprepare
Message-Id: <20130924130924.61d4ecedf3d4fca5952d55fc@ops.dti.ne.jp>
In-Reply-To: <52410F86.4040301@renesas.com>
References: <52410F86.4040301@renesas.com>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>

Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
migrate to the common clock framework.

Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
---
 drivers/clocksource/em_sti.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 3a5909c..9d17083 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -78,7 +78,7 @@ static int em_sti_enable(struct em_sti_priv *p)
 	int ret;
 
 	/* enable clock */
-	ret = clk_enable(p->clk);
+	ret = clk_prepare_enable(p->clk);
 	if (ret) {
 		dev_err(&p->pdev->dev, "cannot enable clock\n");
 		return ret;
@@ -107,7 +107,7 @@ static void em_sti_disable(struct em_sti_priv *p)
 	em_sti_write(p, STI_INTENCLR, 3);
 
 	/* stop clock */
-	clk_disable(p->clk);
+	clk_disable_unprepare(p->clk);
 }
 
 static cycle_t em_sti_count(struct em_sti_priv *p)
-- 
1.8.1.5

