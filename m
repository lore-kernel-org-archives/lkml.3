Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3JUOTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:19:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49942 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3JUOTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:35 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-3b-526537f6198c
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 09/12] drm: exynos: add compatibles for HDMI and Mixer chips and
 exynos4210 SoC
Date: Mon, 21 Oct 2013 16:18:28 +0200
Message-id: <1382365111-6533-10-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jAd1v5qlBBpc36ljMP3KO1eLK1/ds
	FpPuT2Cx6F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLpxMusllMWXSY1eLwm3ZWixmTX7JZ
	rJ/xmsViXvtLVotjM5YwOvB73Lm2h83jfvdxJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllq
	kb5dAlfG9SW/2QpucFVs/PaCvYGxhbOLkZNDQsBE4vyqZWwQtpjEhXvrwWwhgUWMEs9uZHUx
	cgHZXUwSX9e+ZAdJsAE1HFvymRHEFhFIlPjVfJcZpIhZ4BCTxO6WKcwgCWGBeInv706wgtgs
	AqoSi7tmAcU5OHgFPCQOfnWFWCYv8fR+H9gyTqDwqZdrGSEWu0u8+zaPZQIj7wJGhlWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwUH6TGoH48oGi0OMAhyMSjy8AS4pQUKsiWXFlbmHGCU4
	mJVEeKtMU4OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1
	MDKaaHtlcqZ13HrByP1Fb/OcS/9ZePd5ip3asnjTYet7uZySDk8ndx7nXZEVnhpyJuXKrQD9
	EIvsuomnjO5d4xIvcjYuMZ/7On5/nFfT//yXsjMKnKp7WuzCeU/8Mz5fM+u45Bytp7VZV/pz
	LuvlpNsozDUXmOz0babvQikh80XbPVfKm063VmIpzkg01GIuKk4EAFVNxPROAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add proper compatibles for Mixer and HDMI chip
available on exynos4210 SoCs.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c  |    3 +++
 drivers/gpu/drm/exynos/exynos_mixer.c |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 5adb5c1..ae21fa5 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1874,6 +1874,9 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
 
 static struct of_device_id hdmi_match_types[] = {
 	{
+		.compatible = "samsung,exynos4210-hdmi",
+		.data	= (void	*)HDMI_TYPE13,
+	}, {
 		.compatible = "samsung,exynos5-hdmi",
 		.data	= (void	*)HDMI_TYPE14,
 	}, {
diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index 63bc5f9..892afb5 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -1161,6 +1161,9 @@ static struct platform_device_id mixer_driver_types[] = {
 
 static struct of_device_id mixer_match_types[] = {
 	{
+		.compatible = "samsung,exynos4-mixer",
+		.data	= &exynos4_mxr_drv_data,
+	}, {
 		.compatible = "samsung,exynos5-mixer",
 		.data	= &exynos5250_mxr_drv_data,
 	}, {
-- 
1.7.9.5

