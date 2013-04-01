Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab3DAJqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:46:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35273 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab3DAJq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:46:28 -0400
X-AuditID: cbfee68e-b7f946d000001e37-e7-515957731faf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 13/27] rtc: rtc-mc13xxx: use devm_*() functions
Date: Mon, 01 Apr 2013 18:46:26 +0900
Message-id: <001801ce2ebd$c77d5720$56780560$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAJQkA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI93i8MhAg+VzpS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK+HlIr+Aob0XD3bVsDYzzubsYOTkkBEwktl27xg5hi0lcuLeerYuRi0NIYBmjxNWT
	k1hhipoafrBDJBYxSsxp+8MK4fxilHgw/xFYO5uAmsSXL4eBbA4OEQF9ibYWDZAaZoFeRokz
	vbvBaoQEbCV+nP3ODGJzCthJvFk4jxHEFhawl/h5pZUNxGYRUJV40LwRrJ4XqP5v/yZmCFtQ
	4sfkeywgNrOAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcXJCwiYCTxedYeqBIRiX0v3jGC3CMh
	cI9d4mLfP0aIXQIS3yYfYoHolZXYdIAZ4mFJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsY
	RVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQiK1bwfjzQPWhxiTgdZPZJYSTc4HRnpeSbyhsZmR
	hamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhg1vq86Wc57turS
	7lur62b9mXDK6Ow3nzu+uWs/TjDeZiSY6flk0wyDotwdSjf9Zjze9df5xLqIsIjViuqLtj92
	3fHQ9EmoeUUp59mvpc+eF4oEvbt2gr1N7qxNdl9t7v0/O7RuZyVk/9hUkFd3T0GX4xTrhp23
	dj8qUHxgmzXnQXjYXdbF53+6K7EUZyQaajEXFScCACmZ/OjqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd3i8MhAg7/PxSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPh5SK/gKG9Fw921bA2M87m7GDk5JARMJJoa
	frBD2GISF+6tZ+ti5OIQEljEKDGn7Q8rhPOLUeLB/EdgVWwCahJfvhwGsjk4RAT0JdpaNEBq
	mAV6GSXO9O4GqxESsJX4cfY7M4jNKWAn8WbhPEYQW1jAXuLnlVY2EJtFQFXiQfNGsHpeoPq/
	/ZuYIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHE51l7oEpEJPa9
	eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKeBZ9I7
	GFc1WBxiFOBgVOLhjbgQESjEmlhWXJl7iFGCg1lJhNfnG1CINyWxsiq1KD++qDQntfgQYzLQ
	oxOZpUST84EpKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GJtaHjREVqa/rfGtYlnp/23WBielGxsXzdn05KFD/Vol5ifrhSN3t+357JLJw9sTMcdrtYDP
	3RTD1Gt/LzKmum93MGg6+kzvR9J1safV2/jkSr9OLrl24cn6to9vjHU6vIJmevF8U9Y+wr6o
	ufKz2Ndpi6xEppmFFAl8LT6a8FdAh+f7oulvPiixFGckGmoxFxUnAgCfcRP0RwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mc13xxx.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 5391b15..7a8ed27 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -316,7 +316,7 @@ static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
 	struct mc13xxx *mc13xxx;
 	int rtcrst_pending;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -351,8 +351,8 @@ static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
 
 	mc13xxx_unlock(mc13xxx);
 
-	priv->rtc = rtc_device_register(pdev->name,
-			&pdev->dev, &mc13xxx_rtc_ops, THIS_MODULE);
+	priv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&mc13xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(priv->rtc)) {
 		ret = PTR_ERR(priv->rtc);
 
@@ -372,7 +372,6 @@ err_reset_irq_request:
 		mc13xxx_unlock(mc13xxx);
 
 		platform_set_drvdata(pdev, NULL);
-		kfree(priv);
 	}
 
 	return ret;
@@ -384,8 +383,6 @@ static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
 
 	mc13xxx_lock(priv->mc13xxx);
 
-	rtc_device_unregister(priv->rtc);
-
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TODA, priv);
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_1HZ, priv);
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_RTCRST, priv);
@@ -394,8 +391,6 @@ static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(priv);
-
 	return 0;
 }
 
-- 
1.7.2.5


