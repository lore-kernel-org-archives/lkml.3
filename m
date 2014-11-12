Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbaKLBfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:35:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609AbaKLBfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:35:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.17 297/319] pinctrl: baytrail: show output gpio state correctly on Intel Baytrail
Date: Wed, 12 Nov 2014 10:17:15 +0900
Message-Id: <20141112011042.030095445@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@linux.intel.com>

commit d90c33818967c5e5371961604ad98b4dea4fa3f4 upstream.

Even if a gpio pin is set to output, we still need to set INPUT_EN
functionality (by clearing INPUT_EN bit) to be able to read the pin's
level.

E.g. without this change, we'll always read low level state from sysfs.

Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-baytrail.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -318,7 +318,7 @@ static int byt_gpio_direction_output(str
 		"Potential Error: Setting GPIO with direct_irq_en to output");
 
 	reg_val = readl(reg) | BYT_DIR_MASK;
-	reg_val &= ~BYT_OUTPUT_EN;
+	reg_val &= ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
 
 	if (value)
 		writel(reg_val | BYT_LEVEL, reg);


