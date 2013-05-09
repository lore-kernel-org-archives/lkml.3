Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3EISfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:35:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3EISfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:35:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,642,1363158000"; 
   d="scan'208";a="45690419"
From: Saravana Kannan <skannan@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v2 1/2] clk: Disable unused clocks after deferred probing is done
Date: Thu,  9 May 2013 11:35:01 -0700
Message-Id: <1368124502-18830-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With deferred probing, late_initcall() is too soon to declare a clock as
unused. Wait for deferred probing to finish before declaring a clock as
unused. Since deferred probing is done in late_initcall(), do the unused
check to late_initcall_sync.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/clk/clk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index fe4055f..5ecb64c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -534,7 +534,7 @@ static int clk_disable_unused(void)
 
 	return 0;
 }
-late_initcall(clk_disable_unused);
+late_initcall_sync(clk_disable_unused);
 
 /***    helper functions   ***/
 
-- 
1.7.8.3

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
