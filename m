Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3JMSTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 14:19:38 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:37434 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754947Ab3JMSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 14:19:37 -0400
Date: Sun, 13 Oct 2013 20:19:33 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.12-rc4 Fixes
Message-ID: <20131013181933.GP401@spo001.leaseweb.com>
References: <20131013180727.GN401@spo001.leaseweb.com> <525AE311.8060605@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525AE311.8060605@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> Looks like the diffs don't match the description.
> Are those possibly the diffs from your previous pull request ?

>From a 3.6 pull request to be precisely :-( I use the old mail
as template and apparently forgot to change the diff...
The correct diff here below.

Thanks,
Wim.

================================================================================
diff --git a/drivers/watchdog/kempld_wdt.c b/drivers/watchdog/kempld_wdt.c
index 491419e..5c3d4df 100644
--- a/drivers/watchdog/kempld_wdt.c
+++ b/drivers/watchdog/kempld_wdt.c
@@ -35,7 +35,7 @@
 #define KEMPLD_WDT_STAGE_TIMEOUT(x)	(0x1b + (x) * 4)
 #define KEMPLD_WDT_STAGE_CFG(x)		(0x18 + (x))
 #define STAGE_CFG_GET_PRESCALER(x)	(((x) & 0x30) >> 4)
-#define STAGE_CFG_SET_PRESCALER(x)	(((x) & 0x30) << 4)
+#define STAGE_CFG_SET_PRESCALER(x)	(((x) & 0x3) << 4)
 #define STAGE_CFG_PRESCALER_MASK	0x30
 #define STAGE_CFG_ACTION_MASK		0x7
 #define STAGE_CFG_ASSERT		(1 << 3)
diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index 1f94b42..f6caa77 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -146,7 +146,7 @@ static const struct watchdog_ops sunxi_wdt_ops = {
 	.set_timeout	= sunxi_wdt_set_timeout,
 };
 
-static int __init sunxi_wdt_probe(struct platform_device *pdev)
+static int sunxi_wdt_probe(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt;
 	struct resource *res;
@@ -187,7 +187,7 @@ static int __init sunxi_wdt_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit sunxi_wdt_remove(struct platform_device *pdev)
+static int sunxi_wdt_remove(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 42913f1..c9b0c62 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -310,7 +310,8 @@ static long ts72xx_wdt_ioctl(struct file *file, unsigned int cmd,
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
+		error = put_user(0, p);
+		break;
 
 	case WDIOC_KEEPALIVE:
 		ts72xx_wdt_kick(wdt);
