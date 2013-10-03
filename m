Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3JCOEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:04:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62105 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3JCOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:04:34 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-04-524d7970ca7f
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH] fbdev: sh_mobile_hdmi: Use devm_kzalloc()
Date: Thu, 03 Oct 2013 23:04:27 +0900
Message-id: <1380809067-4245-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRsSkRLeg0jfIYMY1c4s569ewWXROXMJu
	cXnXHDaLBXtKLNbPv8XmwOoxu2Mmq8eJGb9ZPPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF
	+nYJXBk3NvxkKVjHXXHixw32BsZVnF2MHBwSAiYSD57LdTFyApliEhfurWfrYuTiEBJYyijx
	ZtUkRoiEicS9O1OZIRLTGSXuzdvMAuG0MUlcurSTFaSKTUBX4smBy8wgtohAuMSjo7NYQYqY
	BRoZJa5fOQGWEBawkujd0Q5mswioSsyd/YMdxOYVcJc4/+s+K8RJChJzJtmA9EoIfGeTWHu7
	DapeQOLb5EMsEDWyEpsOMENcJylxcMUNlgmMggsYGVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn
	525iBAbo6X/Pencw3j5gfYgxGWjcRGYp0eR8YIDnlcQbGpsZWZiamBobmVuakSasJM6r1mId
	KCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx0H+fz6bZ7xQ0HdMXT+6+fyA3RaOvwpxto5yn
	V5haefmuOo74eubF20xvLjAvDlaxntqgtG7WIyfBa08Xe14N/mvos/M+c6J27JId6cYnQrn0
	/c59+37Zcp7+t6BeESkR8Yn+R/b+u9jiIp52bKXP9j2PjjVu+2itt2mm5o3rR1RNZeZqhn1S
	YinOSDTUYi4qTgQAJqfcjGYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jQd2CSt8gg3Xf9S3mrF/DZtE5cQm7
	xeVdc9gsFuwpsVg//xabA6vH7I6ZrB4nZvxm8ejbsorR4/iN7UwenzfJBbBGNTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm3Njwk6VgHXfFiR832BsYV3F2MXJySAiYSNy7
	M5UZwhaTuHBvPVsXIxeHkMB0Rol78zazQDhtTBKXLu1kBaliE9CVeHLgMliHiEC4xKOjs1hB
	ipgFGhklrl85AZYQFrCS6N3RDmazCKhKzJ39gx3E5hVwlzj/6z5QAwfQOgWJOZNsJjByL2Bk
	WMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHAHPpHYwrmywOMQowMGoxMNroOQTJMSaWFZc
	mXuIUYKDWUmEd02xb5AQb0piZVVqUX58UWlOavEhxmSg5ROZpUST84HRmVcSb2hsYmZkaWRu
	aGFkbE6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjDGfj8Q8yBea6mIXN2nSeefUV2uk
	rCpXLOv4osB5x/XsYxm1BTdX2OnKd1geu267aMtq3k1KPAUL7ihaXf+713fK1Xvr/F6++sD7
	N439043bXYnaMt1L+VakTepP3pg3L4v1/58tzBrvDs5k6Xrpc1KDq6dSxEM1S8zS2H5dqkip
	94FTAhc5ViqxFGckGmoxFxUnAgBFDR49xAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() instead of kzalloc() in order to be free
automatically. This makes cleanup paths more simple.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/video/sh_mobile_hdmi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/video/sh_mobile_hdmi.c b/drivers/video/sh_mobile_hdmi.c
index bfe4728..64bd0bf 100644
--- a/drivers/video/sh_mobile_hdmi.c
+++ b/drivers/video/sh_mobile_hdmi.c
@@ -1290,7 +1290,7 @@ static int __init sh_hdmi_probe(struct platform_device *pdev)
 		}
 	}
 
-	hdmi = kzalloc(sizeof(*hdmi), GFP_KERNEL);
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi) {
 		dev_err(&pdev->dev, "Cannot allocate device data\n");
 		return -ENOMEM;
@@ -1304,7 +1304,7 @@ static int __init sh_hdmi_probe(struct platform_device *pdev)
 	if (IS_ERR(hdmi->hdmi_clk)) {
 		ret = PTR_ERR(hdmi->hdmi_clk);
 		dev_err(&pdev->dev, "Unable to get clock: %d\n", ret);
-		goto egetclk;
+		return ret;
 	}
 
 	/* select register access functions */
@@ -1407,8 +1407,6 @@ ereqreg:
 	clk_disable(hdmi->hdmi_clk);
 erate:
 	clk_put(hdmi->hdmi_clk);
-egetclk:
-	kfree(hdmi);
 
 	return ret;
 }
@@ -1433,7 +1431,6 @@ static int __exit sh_hdmi_remove(struct platform_device *pdev)
 		iounmap(hdmi->htop1);
 	iounmap(hdmi->base);
 	release_mem_region(res->start, resource_size(res));
-	kfree(hdmi);
 
 	return 0;
 }
-- 
1.7.9.5

