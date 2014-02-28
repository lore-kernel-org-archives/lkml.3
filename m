Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaB1Mxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:53:30 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:47139 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbaB1Mx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:53:29 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Wolfram Sang <wsa@the-dreams.de>, Maxime Coquelin <maxime.coquelin@st.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com, kernel@stlinux.com
Subject: [PATCH] drivers: i2c: i2c-st: Fix return in case of arbitration lost
Date: Fri, 28 Feb 2014 13:52:56 +0100
Message-Id: <1393591976-10771-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the error returned to the i2c_transfer function
to -EAGAIN in case of arbitratin lost, so that the retry mechanism
can be used.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/i2c/busses/i2c-st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-st.c b/drivers/i2c/busses/i2c-st.c
index 9cf715d..8720161 100644
--- a/drivers/i2c/busses/i2c-st.c
+++ b/drivers/i2c/busses/i2c-st.c
@@ -574,7 +574,7 @@ static irqreturn_t st_i2c_isr_thread(int irq, void *data)
 		writel_relaxed(it, i2c_dev->base + SSC_IEN);
 
 		st_i2c_set_bits(i2c_dev->base + SSC_I2C, SSC_I2C_STOPG);
-		c->result = -EIO;
+		c->result = -EAGAIN;
 		break;
 
 	default:
-- 
1.9.0

