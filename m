Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbaGAONl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:13:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35559 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757948AbaGAONi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:13:38 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 03/33] clk: at91: main: warn when the main crystal frequency is not set
Date: Tue,  1 Jul 2014 16:12:12 +0200
Message-Id: <1404223962-30471-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the main crystal frequency is not set, the main clock is approximated using
the MAINF value in the CKGR_MCFR register. Warn the user in that case.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/clk/at91/clk-main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
index 733306131b99..59fa3cc96c9e 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -388,6 +388,7 @@ static unsigned long clk_main_recalc_rate(struct at91_pmc *pmc,
 	if (parent_rate)
 		return parent_rate;
 
+	pr_warn("Main crystal frequency not set, using approximate value\n");
 	tmp = pmc_read(pmc, AT91_CKGR_MCFR);
 	if (!(tmp & AT91_PMC_MAINRDY))
 		return 0;
-- 
1.9.1

