Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3BRFZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:25:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58667 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3BRFZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:25:20 -0500
X-AuditID: cbfee68e-b7fc26d000001938-37-5121bb3f7697
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000801ce0d98$2e103fd0$8a30bf70$%han@samsung.com>
In-reply-to: <000801ce0d98$2e103fd0$8a30bf70$%han@samsung.com>
Subject: [PATCH 2/2 RESEND] video: exynos_dp: move disable_irq() to
 exynos_dp_suspend()
Date: Mon, 18 Feb 2013 14:25:19 +0900
Message-id: <000901ce0d98$5794c240$06be46c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4NmC3wY06s4orcQzuu4vTFFedQgAAAAeMQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zI1373YqBBjMbjSxO9H1gtbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBk9VxYzFczhrNhyt5etgfE9excjJ4eEgInE5buLoWwx
	iQv31rN1MXJxCAksY5TY37cdrujb173MEIlFjBK3P31khXB+MUrc//yUFaSKTUBN4suXw0Ad
	HBwiAvoSbS0aIDXMAnMZJS6tOcICUiMkYCsx88tmJhCbU8BOYvO9VrC4sECkxJE1RxlBbBYB
	VYkt636B1fAC1d+ffIsVwhaU+DH5Hlg9s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJg
	JLF28XKochGJfS/eMYLcIyGwjl3i2oY+JohdAhLfJh9igeiVldh0gBniYUmJgytusExglJiF
	ZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCoqxvB+PNA9aHGJOB
	1k9klhJNzgdGaV5JvKGxsYmZiamJuaWpuSlpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MDIfFTt9UMXt0wTGjOLS3SeizTM31TH9u58fvfyryL4fb3j/TfpV37tkwgR175lH
	sy6cvPJGpSZ9Q/KMzpT7helXL0ZdnN3eFZQvG6U8x3Fla01NUcZ1mwQLWWeBqadnPTJeKn1Q
	fd1ttp3xR1U/BSUmTGnhuWy/YFbAw1xxkxsT3AKORbjfylRiKc5INNRiLipOBACLY8DByAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAV373YqBBn2/dC1O9H1gtbi8aw6b
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZPVcWMxXM4azY
	creXrYHxPXsXIyeHhICJxLeve5khbDGJC/fWs3UxcnEICSxilLj96SMrhPOLUeL+56esIFVs
	AmoSX74cBurm4BAR0Jdoa9EAqWEWmMsocWnNERaQGiEBW4mZXzYzgdicAnYSm++1gsWFBSIl
	jqw5yghiswioSmxZ9wushheo/v7kW6wQtqDEj8n3wOqZBbQk1u88zgRhy0tsXvOWGWSvhIC6
	xKO/uiBhEQEjibWLl0OVi0jse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXU
	K07MLS7NS9dLzs/dxAiO4WdSOxhXNlgcYhTgYFTi4WXIVwwUYk0sK67MPcQowcGsJMK7SQQo
	xJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnA9JJXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScB
	QgLpiSWp2ampBalFMFuYODilGhinsnncceH9mivwTn5GDstXLQO+RxYcHpNXPLnD0bbx1IKl
	Ni1pTPwX11m3p+SpOIS4rGfl+WjEtfrHKy8Nn9+5wsw/it+cv63ftOP5tf8+Bx4xhk7SSGJd
	dvHCpuypss2LotZseTvtgfg2yZiig+dnJDA/+CgVKub1eSnzASPnqf5/w8w1eFyUWIozEg21
	mIuKEwGEnhgqJQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajay Kumar <ajaykumar.rs@samsung.com>

disable_irq() should be moved to exynos_dp_suspend(), because
enable_irq() is called at exynos_dp_resume().

Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/exynos/exynos_dp_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index c7374c0..de9d4da 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -1124,8 +1124,6 @@ static int exynos_dp_remove(struct platform_device *pdev)
 	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
 
-	disable_irq(dp->irq);
-
 	flush_work(&dp->hotplug_work);
 
 	if (pdev->dev.of_node) {
@@ -1148,6 +1146,8 @@ static int exynos_dp_suspend(struct device *dev)
 	struct exynos_dp_platdata *pdata = dev->platform_data;
 	struct exynos_dp_device *dp = dev_get_drvdata(dev);
 
+	disable_irq(dp->irq);
+
 	flush_work(&dp->hotplug_work);
 
 	if (dev->of_node) {
-- 
1.7.2.5


