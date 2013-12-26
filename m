Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3LZVt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 16:49:29 -0500
Received: from mail-oa0-f74.google.com ([209.85.219.74]:51530 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3LZVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 16:49:00 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Vince Hsu <vinceh@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 2/2] regulator: as3722: set enable time for SD0/1/6
Date: Thu, 26 Dec 2013 13:48:47 -0800
Message-Id: <1388094527-7585-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1388094527-7585-1-git-send-email-abrestic@chromium.org>
References: <1388094527-7585-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vince Hsu <vinceh@nvidia.com>

Add an enable time of 600us for SD0/1/6 to ensure that we have
enough setup time for the power rail.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/regulator/as3722-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index 1e91761..8b17d78 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -845,6 +845,7 @@ static int as3722_regulator_probe(struct platform_device *pdev)
 			}
 			as3722_regs->desc[id].uV_step = 10000;
 			as3722_regs->desc[id].linear_min_sel = 1;
+			as3722_regs->desc[id].enable_time = 600;
 			break;
 		case AS3722_REGULATOR_ID_SD2:
 		case AS3722_REGULATOR_ID_SD3:
-- 
1.8.5.1

