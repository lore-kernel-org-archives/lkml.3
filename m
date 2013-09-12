Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3ILSP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:15:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3ILSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Myugnjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 15/16] drivers/rtc/rtc-max77686.c: Fix wrong register
Date: Thu, 12 Sep 2013 11:15:07 -0700
Message-Id: <20130912181157.844973521@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sangjung Woo <sangjung.woo@samsung.com>

commit 1748cbf7f7c464593232cde914f5a103181a83b5 upstream.

Fix a read of the wrong register when checking whether the RTC timer has
reached the alarm time.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Signed-off-by: Myugnjoo Ham <myungjoo.ham@samsung.com>
Reviewed-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-max77686.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -240,9 +240,9 @@ static int max77686_rtc_read_alarm(struc
 	}
 
 	alrm->pending = 0;
-	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS1, &val);
+	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS2, &val);
 	if (ret < 0) {
-		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
+		dev_err(info->dev, "%s:%d fail to read status2 reg(%d)\n",
 				__func__, __LINE__, ret);
 		goto out;
 	}


