Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337Ab3GCTNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:13:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631Ab3GCTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:21 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-Zama0-QGXAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4efr45Ry3noA:10 a=2KMo9-giAAAA:8 a=KKAkSRfTAAAA:8 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=rwBHQS4kMA4h9rpjHUUA:9 a=-ydLB92TkmgA:10 a=WwgC8nHKvroA:10 a=v3rLFGiuRE8A:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184105.812294771@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [115/141] drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted
 with device tree
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0115-drivers-rtc-rtc-twl.c-fix-missing-device_init_wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 24b8256a1fb28d357bc6fa09184ba29b4255ba5c ]

When booted in legacy mode device_init_wakeup() gets called by
drivers/mfd/twl-core.c when the children are initialized.  However, when
booted using device tree, the children are created with
of_platform_populate() instead add_children().

This means that the RTC driver will not have device_init_wakeup() set,
and we need to call it from the driver probe like RTC drivers typically
do.

Without this we cannot test PM wake-up events on omaps for cases where
there may not be any physical wake-up event.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Reported-by: Kevin Hilman <khilman@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/rtc/rtc-twl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 9277d94..1789a25 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -523,6 +523,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
-- 
1.7.10.4


