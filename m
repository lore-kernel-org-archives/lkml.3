Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaBRWuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:50:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbaBRWrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>,
        Markus Pargmann <mpa@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.13 35/40] pinctrl: imx27: fix offset calculation in imx_read_2bit
Date: Tue, 18 Feb 2014 14:47:36 -0800
Message-Id: <20140218224434.322406492@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ruehl <chris.ruehl@gtsys.com.hk>

commit e3365d0974ed64157f5b5a576c611057dc40a595 upstream.

The offset for the 2bit register calculate wrong, this patch
fixes the problem. The debugfs printout for oconf, iconfa, iconfb
now shows the real values.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Reviewed-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-imx1-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/pinctrl-imx1-core.c
@@ -139,7 +139,7 @@ static int imx1_read_2bit(struct imx1_pi
 		u32 reg_offset)
 {
 	void __iomem *reg = imx1_mem(ipctl, pin_id) + reg_offset;
-	int offset = pin_id % 16;
+	int offset = (pin_id % 16) * 2;
 
 	/* Use the next register if the pin's port pin number is >=16 */
 	if (pin_id % 32 >= 16)


