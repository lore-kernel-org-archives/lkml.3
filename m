Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbaEPPc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:32:26 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:35810 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624AbaEPPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:32:24 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH] drivers: i2c: i2c-st: Update i2c timings
Date: Fri, 16 May 2014 17:32:10 +0200
Message-Id: <1400254330-2547-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-16_05:2014-05-16,2014-05-16,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c timing values specified in the driver are the minimun
values defined in the I2C specifications.
The I2C specification does not specify any default or maximum values.

Some I2C devices are out of spec, and might not work properly with minimum
values.

This patch adds a 10% margin on all the timings.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/i2c/busses/i2c-st.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-st.c b/drivers/i2c/busses/i2c-st.c
index 8720161..09142f1 100644
--- a/drivers/i2c/busses/i2c-st.c
+++ b/drivers/i2c/busses/i2c-st.c
@@ -210,21 +210,21 @@ static inline void st_i2c_clr_bits(void __iomem *reg, u32 mask)
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

