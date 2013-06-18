Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab3FRQcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:32:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab3FRQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:42 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 08/48] drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree
Date: Tue, 18 Jun 2013 09:17:34 -0700
Message-Id: <20130618161727.087336937@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-twl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -524,6 +524,7 @@ static int twl_rtc_probe(struct platform
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:


