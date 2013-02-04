Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3BDC4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:56:01 -0500
Received: from intranet.asianux.com ([58.214.24.6]:37266 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3BDCz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:55:59 -0500
X-Spam-Score: -100.8
Message-ID: <510F233A.3020901@asianux.com>
Date: Mon, 04 Feb 2013 10:55:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Fwd: [PATCH] drivers/regulator/twl-*: bettet set NUL after free
References: <510F226E.4070401@asianux.com>
In-Reply-To: <510F226E.4070401@asianux.com>
X-Forwarded-Message-Id: <510F226E.4070401@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 oh, sorry, not sent to mailing-list, originally.
   (this patch should send to public kernel mailing list)

-------- 原始消息 --------
主题: [PATCH] drivers/regulator/twl-*: bettet set NUL after free
日期: Mon, 04 Feb 2013 10:52:30 +0800
发件人: Chen Gang <gang.chen@asianux.com>
收件人: lrg@ti.com, broonie@opensource.wolfsonmicro.com,  Peter Ujfalusi <peter.ujfalusi@ti.com>, Tony Lindgren <tony@atomide.com>


  in .remove function, better to set NUL after free,  just like others.
    in drivers/power/twl4030_charger.c, has already set NULL after free.
    in drivers/input/keyboard/twl4030_keypad.c, has already set NUL after free.

additional info:
  maybe this is not a bug, only for beautify code (can treat it as minor patch)

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/regulator/twl-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 74508cc..a9ab46a 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1247,6 +1247,7 @@ static int twlreg_remove(struct platform_device *pdev)
 	struct twlreg_info *info = rdev->reg_data;
 
 	regulator_unregister(rdev);
+	platform_set_drvdata(pdev, NULL);
 	kfree(info);
 	return 0;
 }
-- 
1.7.7.6


