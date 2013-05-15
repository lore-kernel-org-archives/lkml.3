Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3EOMEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:04:46 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:54932 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab3EOMEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:04:42 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 05/10] usb: phy: ab8500-usb: fix phy tuning value select logic
Date: Wed, 15 May 2013 14:03:28 +0200
Message-Id: <1368619413-24647-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver supports both ab8500 and ab8505, but the actual phy tuning
values logic sets ab8500 values:

if (!is_ab8500_2p0_or_earlier(ab->ab8500))

which is supposed to set values for ab8500, but incorrectly results true
for ab8505 too.

Fix this by adding an additional is_ab8500(ab->ab8500) check.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index bbe51cc..d105cce 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -835,8 +835,8 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	/* Phy tuning values for AB8500 */
-	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
+	/* Phy tuning values for AB8500 > v2.0 */
+	if (is_ab8500(ab->ab8500) && !is_ab8500_2p0_or_earlier(ab->ab8500)) {
 		/* Enable the PBT/Bank 0x12 access */
 		err = abx500_set_register_interruptible(ab->dev,
 				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x01);
-- 
1.8.2

