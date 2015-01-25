Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbbAYSen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:34:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbbAYSKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.18 132/183] pinctrl: lantiq: remove bogus of_gpio_chip_add
Date: Sun, 25 Jan 2015 10:07:34 -0800
Message-Id: <20150125180815.911309662@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 41f632fe177bc4822c2e8236fe7c291e6e9eb6f8 upstream.

Remove bogus call to of_gpiochip_add (and of_gpio_chip remove in error
path) which is also called when adding the gpio chip.

This prevents adding the same pinctrl range twice.

Fixes: 3f8c50c9b110 ("OF: pinctrl: MIPS: lantiq: implement lantiq/xway
pinctrl support")

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-xway.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -798,10 +798,8 @@ static int pinmux_xway_probe(struct plat
 
 	/* load the gpio chip */
 	xway_chip.dev = &pdev->dev;
-	of_gpiochip_add(&xway_chip);
 	ret = gpiochip_add(&xway_chip);
 	if (ret) {
-		of_gpiochip_remove(&xway_chip);
 		dev_err(&pdev->dev, "Failed to register gpio chip\n");
 		return ret;
 	}


