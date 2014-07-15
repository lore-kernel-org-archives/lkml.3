Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaGOP3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:29:09 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:38651 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbaGOPWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:22:47 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Olivier Bideau <olivier.bideau@st.com>
Subject: [PATCH v3 07/15] drivers: clk: st: STiH407: Support for A9 MUX Clocks
Date: Tue, 15 Jul 2014 17:20:23 +0200
Message-Id: <1405437631-23623-8-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405437631-23623-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1405437631-23623-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-15_05:2014-07-15,2014-07-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch supports the A9-mux clocks used by ClockGenA9

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/clk/st/clkgen-mux.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index a329906..9bdedc8 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -580,6 +580,11 @@ static struct clkgen_mux_data stih416_a9_mux_data = {
 	.shift = 0,
 	.width = 2,
 };
+static struct clkgen_mux_data stih407_a9_mux_data = {
+	.offset = 0x1a4,
+	.shift = 1,
+	.width = 2,
+};
 
 static struct of_device_id mux_of_match[] = {
 	{
@@ -610,6 +615,10 @@ static struct of_device_id mux_of_match[] = {
 		.compatible = "st,stih416-clkgen-a9-mux",
 		.data = &stih416_a9_mux_data,
 	},
+	{
+		.compatible = "st,stih407-clkgen-a9-mux",
+		.data = &stih407_a9_mux_data,
+	},
 	{}
 };
 
-- 
1.9.1

