Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3DARaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:30:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47079 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757488Ab3DAR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 10/15] mfd: wm5102: Only use the lowest three bits of device revision
Date: Mon,  1 Apr 2013 18:28:07 +0100
Message-Id: <1364837292-30191-10-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only the lowest three bits contain device revision for WM5102, the high
bits have been repurposed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 33ddc11..1967a01 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -441,6 +441,7 @@ int arizona_dev_init(struct arizona *arizona)
 			arizona->type = WM5102;
 		}
 		apply_patch = wm5102_patch;
+		arizona->rev &= 0x7;
 		break;
 #endif
 #ifdef CONFIG_MFD_WM5110
-- 
1.7.10.4

