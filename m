Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3ITUOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3ITUOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@linaro.org>, Mike Turquette <mturquette@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 44/93] clk: wm831x: Initialise wm831x pointer on init
Date: Fri, 20 Sep 2013 13:08:39 -0700
Message-Id: <1379707768-1804-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 08442ce993deeb15a070c14cc3f3459e87d111e0 upstream.

Otherwise any attempt to interact with the hardware will crash. This is
what happens when drivers get written blind.

Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/clk/clk-wm831x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index 16ed068..917a3ab 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -360,6 +360,8 @@ static int wm831x_clk_probe(struct platform_device *pdev)
 	if (!clkdata)
 		return -ENOMEM;
 
+	clkdata->wm831x = wm831x;
+
 	/* XTAL_ENA can only be set via OTP/InstantConfig so just read once */
 	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_2);
 	if (ret < 0) {
-- 
1.8.1.2

