Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3FPWWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:22:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46472 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763Ab3FPWI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jingoo Han" <jg1.han@samsung.com>, "Tony Lindgren" <tony@atomide.com>,
        "Kevin Hilman" <khilman@linaro.org>,
        "Alessandro Zummo" <a.zummo@towertech.it>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.809800749@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [75/83] drivers/rtc/rtc-twl.c: fix missing device_init_wakeup()
 when booted with device tree
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 24b8256a1fb28d357bc6fa09184ba29b4255ba5c upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-twl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -490,6 +490,7 @@ static int __devinit twl_rtc_probe(struc
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:

