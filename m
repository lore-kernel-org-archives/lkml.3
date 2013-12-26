Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3LZJMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 04:12:32 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63492 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3LZJMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 04:12:31 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] regulator: s2mps11: Clean up redundant code
Date: Thu, 26 Dec 2013 14:39:03 +0530
Message-Id: <1388048943-5540-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUCK 3 and 4 share the same ramp delay. Hence make it a fall through
case instead of duplicating the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/s2mps11.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 9e61922d8230..d9e557990577 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -70,8 +70,6 @@ static int s2mps11_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 		ramp_delay = s2mps11->ramp_delay2;
 		break;
 	case S2MPS11_BUCK3:
-		ramp_delay = s2mps11->ramp_delay34;
-		break;
 	case S2MPS11_BUCK4:
 		ramp_delay = s2mps11->ramp_delay34;
 		break;
-- 
1.7.9.5

