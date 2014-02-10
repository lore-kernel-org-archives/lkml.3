Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaBJAcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:32:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11229 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaBJAcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:32:14 -0500
X-AuditID: cbfee68e-b7f566d000002344-e3-52f81e0ba72c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2] rtc: rtc-jz4740: Use devm_ioremap_resource()
Date: Mon, 10 Feb 2014 09:32:10 +0900
Message-id: <003801cf25f7$89791f40$9c6b5dc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l94lZ1rkmbBedSjWad9HnMLoirw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI11uuR9BBktmSVosuXiV3WLO+jVs
	FpcXXmK1WDJ5PqvF5V1z2Cz2d3YwOrB57Jl4ks3jxIzfLB5L3hxi9ejbsorRY/q8n0wenzfJ
	BbBFcdmkpOZklqUW6dslcGXcWPuFtaBRsOLuxXVsDYxdfF2MnBwSAiYSp5pPsEPYYhIX7q1n
	62Lk4hASWMYo8bUFxIEomnO6ixUiMZ1R4vfii1DOL0aJu3vuMYJUsQmoSXz5chhoFAeHiIC+
	RFuLBkgNs8B2RomG7kdMIDXCAg4SZ24fYwWxWQRUJf7O/w4W5xWwlfjz+ws7hC0o8WPyPRYQ
	m1lAS2L9zuNMELa8xOY1b5lB5ksIqEs8+qsLEhYR0JN4/KKFGaJERGLfi3eMIHslBK6xS6xb
	NocRYpeAxLfJh1ggemUlNh1ghnhMUuLgihssExjFZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC
	4qT0IiO94sTc4tK8dL3k/NxNjJB47NvBePOA9SHGZKD1E5mlRJPzgfGcVxJvaGxmZGFqYmps
	ZG5pRpqwkjjvoodJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYa29kK9gpX96ibb/nIV9N
	uv05pdeLI2+em27aa+H5U+8b3zaf2VMOCHvZZiu+1C7acvobR53TEuOZm/euUT345+HUzdmd
	xpLXowNzEh47MfB2fe/afuv9ivNBnrY33rp5bbjEenJftNyt7Ud3/g0Xdmr17/H7dIUxuFT9
	UcKPj8rZGpu2PFp0R4mlOCPRUIu5qDgRAJVJfh7dAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQV1uuR9BBpu7RS2WXLzKbjFn/Ro2
	i8sLL7FaLJk8n9Xi8q45bBb7OzsYHdg89kw8yeZxYsZvFo8lbw6xevRtWcXoMX3eTyaPz5vk
	AtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3Fj7hbWgUbDi7sV1bA2M
	XXxdjJwcEgImEnNOd7FC2GISF+6tZ+ti5OIQEpjOKPF78UVWCOcXo8TdPfcYQarYBNQkvnw5
	zN7FyMEhIqAv0daiAVLDLLCdUaKh+xETSI2wgIPEmdvHwKayCKhK/J3/HSzOK2Ar8ef3F3YI
	W1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMoPMlxBQl3j0VxckLCKgJ/H4RQszRImIxL4X7xgn
	MArMQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Gh/JrWDcWWD
	xSFGAQ5GJR7eHX++BwmxJpYVV+YeYpTgYFYS4X15FyjEm5JYWZValB9fVJqTWnyIMRno0YnM
	UqLJ+cBElFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjJ4f
	mQ+16C3i8G1+IW3yzvA/Z/+TrfPKCz+LSk5k8A9XOR0u6z6lUUjs4bl18xLsclQz5S6Hr9nl
	uMLBzFfjkLE/R0raN11F2/2uuj+PzNAW1vn69EGhx1QhARNnxUM6d3RWXJ1yMabds3DzT/X4
	zeF3s87FWTjLlzCc2cx9+3RD08YPUww5lViKMxINtZiLihMB3vijnjoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() in order to make the code simpler,
and move 'struct resource *mem' from 'struct jz4740_rtc' to
jz4740_rtc_probe() because the 'mem' variable is used only in
jz4740_rtc_probe(). Also the redundant return value check of
platform_get_resource() is removed, because the value is checked
by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1
- Removed unnecessary resource flag setting, per Lars-Peter Clausen
- Removed unnecessary the return value check of platform_get_resource()

 drivers/rtc/rtc-jz4740.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 1b126d2..08f5160 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -38,7 +38,6 @@
 #define JZ_RTC_CTRL_ENABLE	BIT(0)
 
 struct jz4740_rtc {
-	struct resource *mem;
 	void __iomem *base;
 
 	struct rtc_device *rtc;
@@ -216,6 +215,7 @@ static int jz4740_rtc_probe(struct platform_device *pdev)
 	int ret;
 	struct jz4740_rtc *rtc;
 	uint32_t scratchpad;
+	struct resource *mem;
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
@@ -227,25 +227,10 @@ static int jz4740_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!rtc->mem) {
-		dev_err(&pdev->dev, "Failed to get platform mmio memory\n");
-		return -ENOENT;
-	}
-
-	rtc->mem = devm_request_mem_region(&pdev->dev, rtc->mem->start,
-					resource_size(rtc->mem), pdev->name);
-	if (!rtc->mem) {
-		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		return -EBUSY;
-	}
-
-	rtc->base = devm_ioremap_nocache(&pdev->dev, rtc->mem->start,
-					resource_size(rtc->mem));
-	if (!rtc->base) {
-		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		return -EBUSY;
-	}
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rtc->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(rtc->base))
+		return PTR_ERR(rtc->base);
 
 	spin_lock_init(&rtc->lock);
 
-- 
1.7.10.4


