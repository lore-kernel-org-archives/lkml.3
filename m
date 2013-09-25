Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3IYAWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:22:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3IYAVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [ 113/117] clk: wm831x: Initialise wm831x pointer on init
Date: Tue, 24 Sep 2013 17:19:39 -0700
Message-Id: <20130925001753.282169466@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 08442ce993deeb15a070c14cc3f3459e87d111e0 upstream.

Otherwise any attempt to interact with the hardware will crash. This is
what happens when drivers get written blind.

Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-wm831x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -360,6 +360,8 @@ static int wm831x_clk_probe(struct platf
 	if (!clkdata)
 		return -ENOMEM;
 
+	clkdata->wm831x = wm831x;
+
 	/* XTAL_ENA can only be set via OTP/InstantConfig so just read once */
 	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_2);
 	if (ret < 0) {


