Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3EIFTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:19:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47201 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3EIFSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:18:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,638,1363158000"; 
   d="scan'208";a="45617295"
From: Saravana Kannan <skannan@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 3/3] regulator: core: Disable unused regulators after deferred probing is done
Date: Wed,  8 May 2013 22:18:46 -0700
Message-Id: <1368076726-11492-4-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With deferred probing, late_initcall() is too soon to declare a regulator
as unused. Wait for deferred probing to finish before declaring a regulator
as unused.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/regulator/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e3661c2..11a0508 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3812,6 +3812,8 @@ static int __init regulator_init_complete(void)
 	if (of_have_populated_dt())
 		has_full_constraints = true;
 
+	wait_for_init_deferred_probe_done();
+
 	mutex_lock(&regulator_list_mutex);
 
 	/* If we have a full configuration then disable any regulators
@@ -3864,4 +3866,4 @@ unlock:
 
 	return 0;
 }
-late_initcall(regulator_init_complete);
+late_initcall_sync(regulator_init_complete);
-- 
1.7.8.3

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
