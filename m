Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3BOXAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:00:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3BOW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 02/10] drivers/rtc/rtc-pl031.c: restore ST variant functionality
Date: Fri, 15 Feb 2013 14:56:34 -0800
Message-Id: <20130215225543.846596739@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130215225543.586012193@linuxfoundation.org>
References: <20130215225543.586012193@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 3399cfb5df9594495b876d1843a7165f77366b2b upstream.

Commit e7e034e18a0a ("drivers/rtc/rtc-pl031.c: fix the missing operation
on enable") accidentally broke the ST variants of PL031.

The bit that is being poked as "clockwatch" enable bit for the ST
variants does the work of bit 0 on this variant.  Bit 0 is used for a
clock divider on the ST variants, and setting it to 1 will affect
timekeeping in a very bad way.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-pl031.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -350,7 +350,9 @@ static int pl031_probe(struct amba_devic
 	/* Enable the clockwatch on ST Variants */
 	if (vendor->clockwatch)
 		data |= RTC_CR_CWEN;
-	writel(data | RTC_CR_EN, ldata->base + RTC_CR);
+	else
+		data |= RTC_CR_EN;
+	writel(data, ldata->base + RTC_CR);
 
 	/*
 	 * On ST PL031 variants, the RTC reset value does not provide correct


