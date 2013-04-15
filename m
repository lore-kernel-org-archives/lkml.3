Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3DOCqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:46:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934223Ab3DOCn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 19/27] gpio: fix wrong checking condition for gpio range
Date: Sun, 14 Apr 2013 19:43:18 -0700
Message-Id: <20130415024232.787790531@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haojian Zhuang <haojian.zhuang@linaro.org>

commit ad4e1a7caf937ad395ced585ca85a7d14395dc80 upstream.

If index++ calculates from 0, the checking condition of "while
(index++)" fails & it doesn't check any more. It doesn't follow
the loop that used at here.

Replace it by endless loop at here. Then it keeps parsing
"gpio-ranges" property until it ends.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-of.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -228,7 +228,7 @@ static void of_gpiochip_add_pin_range(st
 	if (!np)
 		return;
 
-	do {
+	for (;; index++) {
 		ret = of_parse_phandle_with_args(np, "gpio-ranges",
 				"#gpio-range-cells", index, &pinspec);
 		if (ret)
@@ -257,8 +257,7 @@ static void of_gpiochip_add_pin_range(st
 
 		if (ret)
 			break;
-
-	} while (index++);
+	}
 }
 
 #else


