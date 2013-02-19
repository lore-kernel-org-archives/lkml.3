Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442Ab3BSSzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:55:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934432Ab3BSSzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:55:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 76/81] drivers/rtc/rtc-pl031.c: restore ST variant functionality
Date: Tue, 19 Feb 2013 15:49:39 -0300
Message-Id: <1361299784-8830-77-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/rtc/rtc-pl031.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index c42054b..b232996 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -336,7 +336,9 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 	/* Enable the clockwatch on ST Variants */
 	if (ldata->hw_designer == AMBA_VENDOR_ST)
 		data |= RTC_CR_CWEN;
-	writel(data | RTC_CR_EN, ldata->base + RTC_CR);
+	else
+		data |= RTC_CR_EN;
+	writel(data, ldata->base + RTC_CR);
 
 	/*
 	 * On ST PL031 variants, the RTC reset value does not provide correct
-- 
1.7.9.5

