Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaERWgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 18:36:55 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56704 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaERWgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 18:36:53 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH] rtc: hym8563: add optional clock-output-names property
Date: Mon, 19 May 2014 00:40:07 +0200
Message-ID: <5506235.fsodQ5dNGb@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the setting of a custom clock name for the clock provided by
the hym8563 rtc.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt | 3 +++
 drivers/rtc/rtc-hym8563.c                               | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
index 31406fd..5c199ee 100644
--- a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
+++ b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
@@ -9,6 +9,9 @@ Required properties:
 - interrupts: rtc alarm/event interrupt
 - #clock-cells: the value should be 0
 
+Optional properties:
+- clock-output-names: From common clock binding
+
 Example:
 
 hym8563: hym8563@51 {
diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index e5f13c4..6442b5b 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -418,6 +418,9 @@ static struct clk *hym8563_clkout_register_clk(struct hym8563 *hym8563)
 	init.num_parents = 0;
 	hym8563->clkout_hw.init = &init;
 
+	/* optional override of the clockname */
+	of_property_read_string(node, "clock-output-names", &init.name);
+
 	/* register the clock */
 	clk = clk_register(&client->dev, &hym8563->clkout_hw);
 
-- 
1.9.0


