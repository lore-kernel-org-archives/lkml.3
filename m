Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab3CDDvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:51:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33107 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786Ab3CDDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:37 -0500
Message-Id: <20130304033712.135988033@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:53 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 046/153] drivers/rtc/rtc-pl031.c: restore ST variant functionality
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-pl031.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -344,7 +344,9 @@ static int pl031_probe(struct amba_devic
 	/* Enable the clockwatch on ST Variants */
 	if (ldata->hw_designer == AMBA_VENDOR_ST)
 		data |= RTC_CR_CWEN;
-	writel(data | RTC_CR_EN, ldata->base + RTC_CR);
+	else
+		data |= RTC_CR_EN;
+	writel(data, ldata->base + RTC_CR);
 
 	/*
 	 * On ST PL031 variants, the RTC reset value does not provide correct


