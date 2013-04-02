Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975Ab3DBLgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:36:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46554 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760067Ab3DBLdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 06/16] extcon: arizona: Raise minimum microphone impedance for HPDET method
Date: Tue,  2 Apr 2013 12:32:38 +0100
Message-Id: <1364902368-1123-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure greater reliability by increasing the minimum threashold for
identifying a microphone.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 132bc99..2f0bd49 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -519,7 +519,7 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 		 * measure the mic as high impedance.
 		 */
 		if ((info->hpdet_res[0] > info->hpdet_res[1] * 2) ||
-		    (id_gpio && info->hpdet_res[2] > 10)) {
+		    (id_gpio && info->hpdet_res[2] > 1257)) {
 			dev_dbg(arizona->dev, "Detected mic\n");
 			info->mic = true;
 			info->detecting = true;
-- 
1.7.10.4

