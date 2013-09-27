Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3I0H2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:28:01 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47926 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3I0H16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:27:58 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-41-5245337c31af
From: Andrzej Hajda <a.hajda@samsung.com>
To: lee.jones@linaro.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 2/2] max77693: added device tree support
Date: Fri, 27 Sep 2013 09:27:46 +0200
Message-id: <1380266866-32103-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <20130927071744.GA5100@lee--X1>
References: <20130927071744.GA5100@lee--X1>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xa7o1xq5BBpc+MlvcWneO1WL+ESBx
	4M8ORos3vR0sFp1nnzBbnG16w25x/+tRRovLu+awWSy9fpHJYsL0tSwWh1ccYLJY93I6kPWm
	ndXidDerxauDbSwO/B5r5q1h9Fjw+Qq7x+vJExg9Xq2eyepx59oeNo95JwM9+rasYvT4vEnO
	Y+Pc0ADOKC6blNSczLLUIn27BK6Mmc8bmAtWc1Qsu/aUtYHxAVsXIyeHhICJxJRva1ghbDGJ
	C/fWA8W5OIQEljJKbLt/hQnC6WOSuLfwLDNIFZuApsTfzTfBukUEJCQ2/uhjASliFjjFIjG3
	9TYTSEJYwFqice01oCIODhYBVYkPi/xAwrwCzhJ/pl9khtimIPHz8gmwOZwCOhJ7Z89hBLGF
	BLQldp+/xDqBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBA/rKDcfExq0OMAhyM
	Sjy8GVkuQUKsiWXFlbmHGCU4mJVEeGs1XIOEeFMSK6tSi/Lji0pzUosPMTJxcEo1MG6+xOXU
	LL3B3u7wjzLPA3WqfTWWj4rezM4w/CZ90uhVrp+yk5pbYXzr9ZsmL91mlNmH7Z8tsrm0L+bg
	EaGyxa+9bnG/Wv/I5vafI1/WXnaVLdKUDd3qwHZco4l5Uav959eb/a9cXlVlfnRJV/XVl8+L
	st3qHPnbDUXSVHPiGVNYzLYeNth1U4mlOCPRUIu5qDgRAPKFFUlCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds only of_match_table.
There are no device specific properties.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Hi,

Spaces added.

Regards
Andrzej
---
 drivers/mfd/max77693.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 27f5da3..e0b11a9 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -225,11 +225,19 @@ static const struct dev_pm_ops max77693_pm = {
 	.resume = max77693_resume,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id max77693_dt_match[] = {
+	{ .compatible = "maxim,max77693" },
+	{},
+};
+#endif
+
 static struct i2c_driver max77693_i2c_driver = {
 	.driver = {
 		   .name = "max77693",
 		   .owner = THIS_MODULE,
 		   .pm = &max77693_pm,
+		   .of_match_table = of_match_ptr(max77693_dt_match),
 	},
 	.probe = max77693_i2c_probe,
 	.remove = max77693_i2c_remove,
-- 
1.8.1.2

