Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3BVH1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:27:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37814 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3BVH1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:27:23 -0500
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="scan'208";a="26425014"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 1/8] ARM: smp: Lower rating of dummy broadcast device
Date: Thu, 21 Feb 2013 23:27:12 -0800
Message-Id: <1361518039-16663-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc0.16.g20a599e
In-Reply-To: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future the dummy broadcast device will always be
registered with the clockevent core. If the rating of the dummy
is higher than the rating of the real clockevent the clockevents
core will try to replace the real clockevent with the dummy
broadcast. We don't want this to happen, so lower the rating to
something no good clockevent should choose.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index fa86d1c..2d5197d 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -479,7 +479,7 @@ static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
 	evt->features	= CLOCK_EVT_FEAT_ONESHOT |
 			  CLOCK_EVT_FEAT_PERIODIC |
 			  CLOCK_EVT_FEAT_DUMMY;
-	evt->rating	= 400;
+	evt->rating	= 100;
 	evt->mult	= 1;
 	evt->set_mode	= broadcast_timer_set_mode;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

