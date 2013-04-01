Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab3DAN5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:57:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25155 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529Ab3DAN5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:57:43 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-9f-515992558ce0
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Date: Mon, 01 Apr 2013 19:24:00 +0530
Message-id: <1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkWjd0UmSgwcfXEhYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZ4vyWTiaLwysOMFk0nzjFbDHh
	9wU2i/UzXrM48Hks+HyF3WN2w0UWj3knAz32z10D5N39wejRt2UVo8fxG9uZPD5vkgvgiOKy
	SUnNySxLLdK3S+DK+L9uLkvBetmKzz0zGRsYH4l3MXJySAiYSEz92sIOYYtJXLi3nq2LkYtD
	SGApo8SSRceZYIq2b93ICpFYxCgxra+PHcKZwiTxbPZURpAqNgFdiaa3u4BsDg4RgTiJzROE
	QcLMAl1MEkuPgm0TFvCU2PlnDlgJi4CqRN/lPJAwr4CHRF/vGhaIXQoSb24/YwaxOYHKP2xd
	DHaDEFBN+9UTrBA199gllh2qBrFZBAQkvk0+xAIyUkJAVmLTAWaIEkmJgytusExgFF7AyLCK
	UTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzCGTv971r+D8e4B60OMyUDjJjJLiSbnA2MwryTe
	0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M+rVFDhUv
	7Bf+6+t0NVizgtPkpdBVX2X5DjeHBjcu3sPaO63vclict6jtlSqesUbFfdrRA0HCd05KeDzT
	D/3U+ECKa8q/k2EFhqw265Zpn1ATWDd39r3enBVpMyrn3fdadCx/xe1JK1VMXurEPXIpPpHi
	x31Rc4bDkvKW6BMWM+/zxWYsWeigxFKckWioxVxUnAgA9jkIKbcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG7opMhAg2V3eC0O3q+3OLvsIJtF
	8+L1bBa9C66yWVx42sNmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxfktnUwWh1ccYLJoPnGK2WLC
	7wtsFutnvGZx4PNY8PkKu8fshossHvNOBnrsn7sGyLv7g9Gjb8sqRo/jN7YzeXzeJBfAEdXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLeSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeP/urksBetlKz73zGRsYHwk3sXI
	ySEhYCKxfetGVghbTOLCvfVsXYxcHEICixglpvX1sUM4U5gkns2eyghSxSagK9H0dheQzcEh
	IhAnsXmCMEiYWaCLSWLpUbChwgKeEjv/zAErYRFQlei7nAcS5hXwkOjrXcMCsUtB4s3tZ8wg
	NidQ+Yeti5lAbCGgmvarJ1gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREco8+k
	dzCuarA4xCjAwajEwxtxISJQiDWxrLgy9xCjBAezkgjviszIQCHelMTKqtSi/Pii0pzU4kOM
	yUBHTWSWEk3OB6aPvJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLg
	lGpgtLQzt1PjjJ0g9eWzuuODwxXlajYVLLNS8+ev+rRU3EhxwdKWUN3fCYI1RgLdD303may/
	U6OwxePCqvO9m++I5J+5rr6szXB9yUcjmeLaz1NEr29mOpTfOKnz9aKzMl+nrVi50zzXZvG/
	fT+v9FWqCVd73HvwMvfTvr6ket7M7V5us44VPy7sVWIpzkg01GIuKk4EAN4rngMVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding  APIs to handle runtime power management on PHY
devices. PHY consumers may need to wake-up/suspend PHYs
when they work across autosuspend.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 include/linux/usb/phy.h |  141 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 141 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 6b5978f..01bf9c1 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -297,4 +297,145 @@ static inline const char *usb_phy_type_string(enum usb_phy_type type)
 		return "UNKNOWN PHY TYPE";
 	}
 }
+
+static inline void usb_phy_autopm_enable(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return;
+		}
+
+	pm_runtime_enable(x->dev);
+}
+
+static inline void usb_phy_autopm_disable(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return;
+	}
+
+	pm_runtime_disable(x->dev);
+}
+
+static inline int usb_phy_autopm_get(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return -ENODEV;
+	}
+
+	return pm_runtime_get(x->dev);
+}
+
+static inline int usb_phy_autopm_get_sync(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return -ENODEV;
+	}
+
+	return pm_runtime_get_sync(x->dev);
+}
+
+static inline int usb_phy_autopm_put(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return -ENODEV;
+	}
+
+	return pm_runtime_put(x->dev);
+}
+
+static inline int usb_phy_autopm_put_sync(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return -ENODEV;
+	}
+
+	return pm_runtime_put_sync(x->dev);
+}
+
+static inline void usb_phy_autopm_allow(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return;
+	}
+
+	pm_runtime_allow(x->dev);
+}
+
+static inline void usb_phy_autopm_forbid(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return;
+	}
+
+	pm_runtime_forbid(x->dev);
+}
+
+static inline int usb_phy_autopm_set_active(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return -ENODEV;
+	}
+
+	return pm_runtime_set_active(x->dev);
+}
+
+static inline void usb_phy_autopm_set_suspended(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return;
+	}
+
+	pm_runtime_set_suspended(x->dev);
+}
+
+static inline bool usb_phy_autopm_suspended(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return 0;
+	}
+
+	return pm_runtime_suspended(x->dev);
+}
+
+static inline bool usb_phy_autopm_active(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return 0;
+	}
+
+	return pm_runtime_active(x->dev);
+}
+
+static inline int usb_phy_autopm_suspend(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return -ENODEV;
+	}
+
+	return pm_runtime_suspend(x->dev);
+}
+
+static inline int usb_phy_autopm_resume(struct usb_phy *x)
+{
+	if (!x || !x->dev) {
+		dev_err(x->dev, "no PHY or attached device available\n");
+		return -ENODEV;
+	}
+
+	return pm_runtime_resume(x->dev);
+}
+
 #endif /* __LINUX_USB_PHY_H */
-- 
1.7.6.5

