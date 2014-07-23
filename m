Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaGWPoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:44:34 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57058 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757616AbaGWPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:44:32 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH v2] drivers: i2c: i2c-st: Update i2c timings
Date: Wed, 23 Jul 2014 17:44:07 +0200
Message-Id: <1406130247-19197-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-23_06:2014-07-23,2014-07-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c timing values specified in the driver are the minimun values defined
in the I2C specifications.
The I2C specification does not specify any default or maximum values.

Some I2C devices are out of spec, such as the HDMI link of the Toshiba 19AV600
TV, and might not work properly with minimum values.

This patch adds a 10% margin on all the timings in both Normal and Fast modes.

Trial and error method have been used to find the minimum margin necessary to
have the out-of-spec device working, and a security margin has been added.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/i2c/busses/i2c-st.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-st.c b/drivers/i2c/busses/i2c-st.c
index 95b94767..4ab14ad 100644
--- a/drivers/i2c/busses/i2c-st.c
+++ b/drivers/i2c/busses/i2c-st.c
@@ -206,25 +206,31 @@ static inline void st_i2c_clr_bits(void __iomem *reg, u32 mask)
 	writel_relaxed(readl_relaxed(reg) & ~mask, reg);
 }
 
-/* From I2C Specifications v0.5 */
+/*
+ * From I2C Specifications v0.5.
+ *
+ * All the values below have +10% margin added to be
+ * compatible with some out-of-spec devices,
+ * like HDMI link of the Toshiba 19AV600 TV.
+ */
 static struct st_i2c_timings i2c_timings[] = {
 	[I2C_MODE_STANDARD] = {
 		.rate			= 100000,
-		.rep_start_hold		= 4000,
-		.rep_start_setup	= 4700,
-		.start_hold		= 4000,
-		.data_setup_time	= 250,
-		.stop_setup_time	= 4000,
-		.bus_free_time		= 4700,
+		.rep_start_hold		= 4400,
+		.rep_start_setup	= 5170,
+		.start_hold		= 4400,
+		.data_setup_time	= 275,
+		.stop_setup_time	= 4400,
+		.bus_free_time		= 5170,
 	},
 	[I2C_MODE_FAST] = {
 		.rate			= 400000,
-		.rep_start_hold		= 600,
-		.rep_start_setup	= 600,
-		.start_hold		= 600,
-		.data_setup_time	= 100,
-		.stop_setup_time	= 600,
-		.bus_free_time		= 1300,
+		.rep_start_hold		= 660,
+		.rep_start_setup	= 660,
+		.start_hold		= 660,
+		.data_setup_time	= 110,
+		.stop_setup_time	= 660,
+		.bus_free_time		= 1430,
 	},
 };
 
-- 
1.9.1

