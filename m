Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3DRHPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:15:31 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:51658 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051Ab3DRHPa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:15:30 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 18 Apr 2013 09:15:20 +0200
Subject: [PATCH] pinctrl: pinctrl-abx500: fix issue when no pdata
Thread-Topic: [PATCH] pinctrl: pinctrl-abx500: fix issue when no pdata
Thread-Index: Ac48BHxX4G1cOuJ1S5CO8ap0OeSBxQ==
Message-ID: <516F9D88.50408@st.com>
References: <516EBB9E.4080601@st.com>
In-Reply-To: <516EBB9E.4080601@st.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
x-forwarded-message-id: <516EBB9E.4080601@st.com>
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an issue when probing pinctrl-abx500 with no
platform data

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c
b/drivers/pinctrl/pinctrl-abx500.c
index 0cf3fa4..04b1408 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -880,7 +880,6 @@ static int abx500_gpio_probe(struct platform_device
*pdev)
 	pct->parent = dev_get_drvdata(pdev->dev.parent);
 	pct->chip = abx500gpio_chip;
 	pct->chip.dev = &pdev->dev;
-	pct->chip.base = pdata->gpio_base;
 	pct->chip.base = (np) ? -1 : pdata->gpio_base;

 	/* initialize the lock */
-- 1.7.10