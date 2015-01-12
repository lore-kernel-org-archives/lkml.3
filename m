Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbbALSGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57540 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbbALSGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Lindgren <tony@atomide.com>, Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 053/216] mfd: twl4030-power: Fix regression with missing compatible flag
Date: Mon, 12 Jan 2015 18:02:50 +0000
Message-Id: <1421085933-32536-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 1b9b46d05f887aec418b3a5f4f55abf79316fcda upstream.

Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
configuration") accidentally removed the compatible flag for
"ti,twl4030-power" that should be there as documented in the
binding.

If "ti,twl4030-power" only the poweroff configuration is done
by the driver.

Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
Reported-by: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/twl4030-power.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 542f1a8247f5..33a35fbd48c9 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -828,6 +828,9 @@ static struct twl4030_power_data osc_off_idle = {
 
 static struct of_device_id twl4030_power_of_match[] = {
 	{
+		.compatible = "ti,twl4030-power",
+	},
+	{
 		.compatible = "ti,twl4030-power-reset",
 		.data = &omap3_reset,
 	},
-- 
2.1.4

