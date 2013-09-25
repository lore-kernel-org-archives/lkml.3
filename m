Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3IYATf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:19:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3IYARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:17:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [ 106/110] clk: wm831x: Initialise wm831x pointer on init
Date: Tue, 24 Sep 2013 17:15:44 -0700
Message-Id: <20130925001334.896357846@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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


