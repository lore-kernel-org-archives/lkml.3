Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaBOUWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:22:38 -0500
Received: from vm1.sequanux.org ([188.165.36.56]:39899 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbaBOUWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:22:37 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Feb 2014 15:22:37 EST
From: Simon Guinot <simon.guinot@sequanux.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Simon Guinot <simon.guinot@sequanux.org>
Subject: [PATCH 1/2] rtc: rtc-ds1307: fix sysfs wakealarm attribute creation
Date: Sat, 15 Feb 2014 21:15:22 +0100
Message-Id: <1392495323-22875-2-git-send-email-simon.guinot@sequanux.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392495323-22875-1-git-send-email-simon.guinot@sequanux.org>
References: <1392495323-22875-1-git-send-email-simon.guinot@sequanux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow the creation of the sysfs attribute wakealarm, this
patch moves the device_set_wakeup_capable() call above the RTC device
registration.

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
---
 drivers/rtc/rtc-ds1307.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 4e75345a559a..8c70b2238e88 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -927,6 +927,7 @@ read_rtc:
 				bin2bcd(tmp));
 	}
 
+	device_set_wakeup_capable(&client->dev, want_irq);
 	ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
 				&ds13xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1307->rtc)) {
@@ -945,7 +946,6 @@ read_rtc:
 			goto exit;
 		}
 
-		device_set_wakeup_capable(&client->dev, 1);
 		set_bit(HAS_ALARM, &ds1307->flags);
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
-- 
1.8.5.3

