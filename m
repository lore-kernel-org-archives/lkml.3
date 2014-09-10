Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaIJUoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:44:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaIJUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:44:13 -0400
Date: Wed, 10 Sep 2014 13:44:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, heiko@sntech.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v10 1/3] RTC: RK808: add RTC driver for RK808
Message-Id: <20140910134411.8128acce79f2423d4448e8f4@linux-foundation.org>
In-Reply-To: <1410311886-4579-2-git-send-email-zyw@rock-chips.com>
References: <1410311886-4579-1-git-send-email-zyw@rock-chips.com>
	<1410311886-4579-2-git-send-email-zyw@rock-chips.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 09:18:04 +0800 Chris Zhong <zyw@rock-chips.com> wrote:

> Adding RTC driver for supporting RTC device present inside RK808 PMIC.
> 
> ...
>
> +	ret = rtc_valid_tm(&tm);
> +	if (ret) {
> +		dev_warn(&pdev->dev, "invalid date/time and init time\n");
> +		rk808_rtc_set_time(&pdev->dev, &tm_def);
> +	}

This is somewhat unusual.  Most drivers will emit a warning and give up
when they find the time is wrong.  Why is this driver different and is
this desirable behaviour?


Also, I did this:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rk808-add-rtc-driver-for-rk808-fix

make tm_def static

Cc: Chris Zhong <zyw@rock-chips.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rk808.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-rk808-add-rtc-driver-for-rk808-fix drivers/rtc/Kconfig
diff -puN drivers/rtc/Makefile~rtc-rk808-add-rtc-driver-for-rk808-fix drivers/rtc/Makefile
diff -puN drivers/rtc/rtc-rk808.c~rtc-rk808-add-rtc-driver-for-rk808-fix drivers/rtc/rtc-rk808.c
--- a/drivers/rtc/rtc-rk808.c~rtc-rk808-add-rtc-driver-for-rk808-fix
+++ a/drivers/rtc/rtc-rk808.c
@@ -326,14 +326,14 @@ static SIMPLE_DEV_PM_OPS(rk808_rtc_pm_op
 	rk808_rtc_suspend, rk808_rtc_resume);
 
 /* 2014.1.1 12:00:00 Saturday */
-struct rtc_time tm_def = {
-			.tm_wday = 6,
-			.tm_year = 114,
-			.tm_mon = 0,
-			.tm_mday = 1,
-			.tm_hour = 12,
-			.tm_min = 0,
-			.tm_sec = 0,
+static struct rtc_time tm_def = {
+	.tm_wday = 6,
+	.tm_year = 114,
+	.tm_mon = 0,
+	.tm_mday = 1,
+	.tm_hour = 12,
+	.tm_min = 0,
+	.tm_sec = 0,
 };
 
 static int rk808_rtc_probe(struct platform_device *pdev)
_


