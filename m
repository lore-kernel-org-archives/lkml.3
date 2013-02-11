Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3BKQ2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:28:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35481 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757968Ab3BKQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 10/11] extcon: arizona: Always take the first HPDET reading as the final one
Date: Mon, 11 Feb 2013 16:27:05 +0000
Message-Id: <1360600026-16878-10-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should always be the most accurate reading for supported accessory
configurations.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index aeaf217..d991842 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -451,6 +451,10 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 			info->hpdet_res[0], info->hpdet_res[1],
 			info->hpdet_res[2]);
 
+
+		/* Take the headphone impedance for the main report */
+		*reading = info->hpdet_res[0];
+
 		/*
 		 * Either the two grounds measure differently or we
 		 * measure the mic as high impedance.
@@ -466,9 +470,6 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 				dev_err(arizona->dev,
 					"Failed to report mic: %d\n", ret);
 			}
-
-			/* Take the headphone impedance for the main report */
-			*reading = info->hpdet_res[1];
 		} else {
 			dev_dbg(arizona->dev, "Detected headphone\n");
 		}
-- 
1.7.10.4

