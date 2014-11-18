Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaKRCS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:18:27 -0500
Received: from smtprelay0168.hostedemail.com ([216.40.44.168]:32911 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751464AbaKRCSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:18:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:4321:5007:6261:7514:10004:10400:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13069:13311:13357:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frog42_f0d5b3c58154
X-Filterd-Recvd-Size: 2859
Message-ID: <1416277102.29010.14.camel@perches.com>
Subject: [PATCH (sent originally to netdev)] device: Add dev_<level>_once
 variants
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 17 Nov 2014 18:18:22 -0800
In-Reply-To: <5467C3BA.6090003@gmail.com>
References: <1416031715-32498-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1416031715-32498-2-git-send-email-jeffrey.t.kirsher@intel.com>
	 <5467C3BA.6090003@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the equivalents to pr_<level>_once.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/device.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index ce1f2160..a1ee071 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1118,6 +1118,41 @@ do {						     \
 })
 #endif
 
+#ifdef CONFIG_PRINTK
+#define dev_level_once(dev_level, dev, fmt, ...)			\
+do {									\
+	static bool __print_once __read_mostly;				\
+									\
+	if (!__print_once) {						\
+		__print_once = true;					\
+		dev_level(dev, fmt, ##__VA_ARGS__);			\
+	}								\
+} while (0)
+#else
+#define dev_level_once(dev_level, dev, fmt, ...)			\
+do {									\
+	if (0)								\
+		dev_level(dev, fmt, ##__VA_ARGS__);			\
+} while (0)
+#endif
+
+#define dev_emerg_once(dev, fmt, ...)					\
+	dev_level_once(dev_emerg, dev, fmt, ##__VA_ARGS__)
+#define dev_alert_once(dev, fmt, ...)					\
+	dev_level_once(dev_alert, dev, fmt, ##__VA_ARGS__)
+#define dev_crit_once(dev, fmt, ...)					\
+	dev_level_once(dev_crit, dev, fmt, ##__VA_ARGS__)
+#define dev_err_once(dev, fmt, ...)					\
+	dev_level_once(dev_err, dev, fmt, ##__VA_ARGS__)
+#define dev_warn_once(dev, fmt, ...)					\
+	dev_level_once(dev_warn, dev, fmt, ##__VA_ARGS__)
+#define dev_notice_once(dev, fmt, ...)					\
+	dev_level_once(dev_notice, dev, fmt, ##__VA_ARGS__)
+#define dev_info_once(dev, fmt, ...)					\
+	dev_level_once(dev_info, dev, fmt, ##__VA_ARGS__)
+#define dev_dbg_once(dev, fmt, ...)					\
+	dev_level_once(dev_info, dev, fmt, ##__VA_ARGS__)
+
 #define dev_level_ratelimited(dev_level, dev, fmt, ...)			\
 do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\


