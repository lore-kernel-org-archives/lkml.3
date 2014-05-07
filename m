Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaEGURv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:17:51 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:35764 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaEGURr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:17:47 -0400
X-LoopCount0: from 10.208.46.70
X-IronPort-AV: E=Sophos;i="4.97,1006,1389765600"; 
   d="scan'208";a="501200764"
From: Mario Limonciello <mario_limonciello@dell.com>
To: matthew.garrett@nebula.com
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Mario Limonciello <mario_limonciello@dell.com>
Subject: [PATCH 1/2] alienware-wmi: Update WMAX brightness method limit to 15
Date: Wed,  7 May 2014 15:08:09 -0500
Message-Id: <1399493290-4572-1-git-send-email-mario_limonciello@dell.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This more closely reflects what the hardware can actually support.

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
---
 drivers/platform/x86/alienware-wmi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/x86/alienware-wmi.c b/drivers/platform/x86/alienware-wmi.c
index 541f951..e5329ea 100644
--- a/drivers/platform/x86/alienware-wmi.c
+++ b/drivers/platform/x86/alienware-wmi.c
@@ -350,12 +350,11 @@ static int alienware_zone_init(struct platform_device *dev)
 	char *name;
 
 	if (interface == WMAX) {
-		global_led.max_brightness = 100;
 		lighting_control_state = WMAX_RUNNING;
 	} else if (interface == LEGACY) {
-		global_led.max_brightness = 0x0F;
 		lighting_control_state = LEGACY_RUNNING;
 	}
+	global_led.max_brightness = 0x0F;
 	global_brightness = global_led.max_brightness;
 
 	/*
-- 
1.7.9.5

