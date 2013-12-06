Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162387Ab3LFNZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:25:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308Ab3LFNEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 199/272] i2c: wmt: add missing clk_disable_unprepare() on error
Date: Fri,  6 Dec 2013 12:58:08 +0000
Message-Id: <1386334761-25517-200-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 2dc9688a106886db7191d30f30ffd61fde827efd upstream.

Add the missing clk_disable_unprepare() before return
from wmt_i2c_reset_hardware() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/i2c-wmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index baaa7d1..b04d37a 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -350,6 +350,7 @@ static int wmt_i2c_reset_hardware(struct wmt_i2c_dev *i2c_dev)
 	err = clk_set_rate(i2c_dev->clk, 20000000);
 	if (err) {
 		dev_err(i2c_dev->dev, "failed to set clock = 20Mhz\n");
+		clk_disable_unprepare(i2c_dev->clk);
 		return err;
 	}
 
-- 
1.8.3.2

