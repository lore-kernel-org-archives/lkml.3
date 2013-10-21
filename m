Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3JUOWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:22:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34150 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3JUOTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:30 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-88-526537f152f1
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 08/12] drm: exynos: hdmi: simplify extracting hpd-gpio from DT
Date: Mon, 21 Oct 2013 16:18:27 +0200
Message-id: <1382365111-6533-9-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jAd2P5qlBBrtvKlnMP3KO1eLK1/ds
	FpPuT2Cx6F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLpxMusllMWXSY1eLwm3ZWixmTX7JZ
	rJ/xmsViXvtLVotjM5YwOvB73Lm2h83jfvdxJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllq
	kb5dAlfG3LMbmQrWclZcvv6dsYHxDnsXIyeHhICJxK4fT5ghbDGJC/fWs3UxcnEICSxilGia
	O48dwuliktiwdQ5YFRtQx7ElnxlBbBGBRIlfzXeZQYqYBQ4xSexumQJWJCzgI/FqVi+YzSKg
	KvFh6zMwm1fAXeJAzyOodfIST+/3sYHYnAIeEqdergUbKgRU8+7bPJYJjLwLGBlWMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgQH6jPpHYyrGiwOMQpwMCrx8Aa4pAQJsSaWFVfmHmKU4GBW
	EuGtMk0NEuJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cDo
	1/xPT+xJalE701Pj5rtT3K+XzGf5/r1VL4+psPeEsU3f/3VODhMztW9kLg1OObtuxV/ensLl
	q3a/SbRo6PKsW1yp9OiweNCkJt97DO5yF9RzG3SSlTwv3QoPePO0Q6Z4ysWcm3EPW20fRusf
	ybnuUpvpcnZOYZr3hPNpjzdOd/RZq8RrI63EUpyRaKjFXFScCAB6Vq7lUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates redundant checks while retrieving HPD gpio from DT during
HDMI's probe().

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index e36588a..5adb5c1 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1858,23 +1858,18 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
 {
 	struct device_node *np = dev->of_node;
 	struct s5p_hdmi_platform_data *pd;
-	u32 value;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 	if (!pd)
-		goto err_data;
+		return NULL;
 
-	if (!of_find_property(np, "hpd-gpio", &value)) {
+	pd->hpd_gpio = of_get_named_gpio_flags(np, "hpd-gpio", 0, NULL);
+	if (pd->hpd_gpio < 0) {
 		DRM_ERROR("no hpd gpio property found\n");
-		goto err_data;
+		return NULL;
 	}
 
-	pd->hpd_gpio = of_get_named_gpio(np, "hpd-gpio", 0);
-
 	return pd;
-
-err_data:
-	return NULL;
 }
 
 static struct of_device_id hdmi_match_types[] = {
-- 
1.7.9.5

