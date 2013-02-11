Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab3BKQaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:30:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35472 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757957Ab3BKQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:13 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 06/11] extcon: arizona: Remove extra jack flip increment
Date: Mon, 11 Feb 2013 16:27:01 +0000
Message-Id: <1360600026-16878-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index aa72431..c17a41f 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -750,8 +750,6 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	 * impedence then give up and report headphones.
 	 */
 	if (info->detecting && (val & 0x3f8)) {
-		info->jack_flips++;
-
 		if (info->jack_flips >= info->micd_num_modes) {
 			dev_dbg(arizona->dev, "Detected HP/line\n");
 			arizona_identify_headphone(info);
-- 
1.7.10.4

