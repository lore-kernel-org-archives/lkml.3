Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaEFRCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:02:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56922 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbaEFRBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:01:55 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Alessandro Zummo <a.zummo@towertech.it>, akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: hym8563: set uie_unsupported
Date: Tue, 06 May 2014 19:02:28 +0200
Message-ID: <5265378.nvzJISTqrS@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alarm of the hym8563 only supports a minute accuracy, while
the uie wants an alarm one second in the future. Therefore things like
the select() syscall will fail with a timeout, because the next alarm
will happen in a worst case of 60 seconds.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Cc: stable@vger.kernel.org
---
 drivers/rtc/rtc-hym8563.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index bd628a6..e5f13c4 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -569,6 +569,9 @@ static int hym8563_probe(struct i2c_client *client,
 	if (IS_ERR(hym8563->rtc))
 		return PTR_ERR(hym8563->rtc);
 
+	/* the hym8563 alarm only supports a minute accuracy */
+	hym8563->rtc->uie_unsupported = 1;
+
 #ifdef CONFIG_COMMON_CLK
 	hym8563_clkout_register_clk(hym8563);
 #endif
-- 
1.9.0


