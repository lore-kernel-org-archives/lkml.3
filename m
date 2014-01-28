Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaA1Iro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:47:44 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:55046 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaA1Irm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:47:42 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: si5351: fix non-DT build breakage
Date: Tue, 28 Jan 2014 09:47:29 +0100
Message-Id: <1390898849-761-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390682911-9022-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390682911-9022-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch ("clk: si5351: remove variant from platform_data") changed parameters
passed to si5351_dt_parse. While it builds fine with CONFIG_OF, the non-DT
stub of si5351_dt_parse has not been updated and fails to build there.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reported-by: Kbuild Test Robot <fengguang.wu@intel.com>
---
Mike,

sorry for that one. Feel free to squash this one into the original patch.

Sebastian

Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk-si5351.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index b95aa09b7aed..e9ee2e12d9cc 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -1293,7 +1293,8 @@ static int si5351_dt_parse(struct i2c_client *client,
 	return 0;
 }
 #else
-static int si5351_dt_parse(struct i2c_client *client)
+static int si5351_dt_parse(struct i2c_client *client,
+			   enum si5351_variant variant)
 {
 	return 0;
 }
-- 
1.8.5.2

