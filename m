Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab3DAN57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:57:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57878 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529Ab3DAN5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:57:52 -0400
X-AuditID: cbfee68e-b7f946d000001e37-10-5159925e0f6c
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 04/11] usb: dwc3: Add runtime power management callbacks
Date: Mon, 01 Apr 2013 19:24:03 +0530
Message-id: <1364824448-14732-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkTjduUmSgQeN+C4uD9+stzi47yGbR
	vHg9m0XvgqtsFhee9rBZXN41h81i9pJ+FosZ5/cxWSxa1spscX5LJ5PF4RUHmCyaT5xitpjw
	+wKbxfoZr1kc+DwWfL7C7jG74SKLx7yTgR77564B8u7+YPTo27KK0eP4je1MHp83yQVwRHHZ
	pKTmZJalFunbJXBlfHz+lrVgI1/Fpu1T2BsY33J3MXJySAiYSMz5cosZwhaTuHBvPVsXIxeH
	kMBSRomzrf+ZYIp+TD/ICGILCSxilLj7QwmiaAqTxPZDC9hBEmwCuhJNb3cBFXFwiAjESWye
	IAwSZhboYpJYelQcxBYW8JZYt/so2BwWAVWJ+VcvMIGU8wp4SNw7WASxSkHize1nYPdwCnhK
	fNi6mAlirYdE+9UTrCBrJQQesUts3XqcBWKOgMS3yYdYQOZICMhKbDoA9YukxMEVN1gmMAov
	YGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREYQ6f/PevbwXjzgPUhxmSgcROZpUST84Ex
	mFcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpiW
	L7HPt8canTjIF72xUUZ98rUJ3C0a194L7py8+Ni6TWkuE7Z4e/05Eb9db+amoq2fDd4pbHP+
	6r9O9424+iGT+N+lV2uXv/k4/9hV2fBkucWrJnnbrtU7cfSB9aFyK1Ypl8DNKgvulcl3z/zU
	MmWLW1auWuys86++mexmjFwoEhJ/T+vuh7tKLMUZiYZazEXFiQAh2HavtwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xgG7cpMhAg5OX9SwO3q+3OLvsIJtF
	8+L1bBa9C66yWVx42sNmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxfktnUwWh1ccYLJoPnGK2WLC
	7wtsFutnvGZx4PNY8PkKu8fshossHvNOBnrsn7sGyLv7g9Gjb8sqRo/jN7YzeXzeJBfAEdXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLeSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePj87esBRv5KjZtn8LewPiWu4uR
	k0NCwETix/SDjBC2mMSFe+vZQGwhgUWMEnd/KHUxcgHZU5gkth9awA6SYBPQlWh6uwuogYND
	RCBOYvMEYZAws0AXk8TSo+IgtrCAt8S63UfBZrIIqErMv3qBCaScV8BD4t7BIohVChJvbj9j
	BrE5BTwlPmxdzASx1kOi/eoJ1gmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfo
	M6kdjCsbLA4xCnAwKvHwRlyICBRiTSwrrsw9xCjBwawkwrsiMzJQiDclsbIqtSg/vqg0J7X4
	EGMy0FETmaVEk/OBySOvJN7Q2MTc1NjU0sTCxMySNGElcd4DrdaBQgLpiSWp2ampBalFMFuY
	ODilGhh9/+07G10963DZBzWNtbn7Xx9ZvXjRkYOODcU9a8+eEF70hjvL/2lk0cILtXNcVnF8
	yC5fGDq34zP/om5bx7Nst3Om+DckmS1aZiCb6FN0gI+7g9fy7/UjQc4/GGokuuZ//ra8+sS7
	pUVTf8Q73Cn/WW9g5DY3ae5pwcJwkUl3l9ip1DwsVt2txFKckWioxVxUnAgAOIzHjRQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now it doesn't handle full runtime suspend/resume
functionality. However it allows to handle PHYs' sleep
and wakeup across runtime suspend/resume.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/core.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index e250828..65a3adf 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -745,11 +745,54 @@ static int dwc3_resume(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int dwc3_runtime_suspend(struct device *dev)
+{
+	struct dwc3	*dwc = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = usb_phy_autopm_put_sync(dwc->usb2_phy);
+	if (ret)
+		dev_warn(dev, "Can't autosuspend usb2-phy\n");
+
+	ret = usb_phy_autopm_put_sync(dwc->usb3_phy);
+	if (ret)
+		dev_warn(dev, "Can't autosuspend usb3-phy\n");
+
+	return ret;
+}
+
+static int dwc3_runtime_resume(struct device *dev)
+{
+	struct dwc3	*dwc = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = usb_phy_autopm_get_sync(dwc->usb2_phy);
+	if (ret) {
+		dev_err(dev, "usb2-phy: get sync failed with err %d\n", ret);
+		return ret;
+	}
+
+	ret = usb_phy_autopm_get_sync(dwc->usb3_phy);
+	if (ret) {
+		dev_err(dev, "usb3-phy: get sync failed with err %d\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+#else
+#define dwc3_runtime_suspend		NULL
+#define dwc3_runtime_resume		NULL
+#endif
+
 static const struct dev_pm_ops dwc3_dev_pm_ops = {
 	.prepare	= dwc3_prepare,
 	.complete	= dwc3_complete,
 
 	SET_SYSTEM_SLEEP_PM_OPS(dwc3_suspend, dwc3_resume)
+	SET_RUNTIME_PM_OPS(dwc3_runtime_suspend,
+				dwc3_runtime_resume, NULL)
 };
 
 #define DWC3_PM_OPS	&(dwc3_dev_pm_ops)
-- 
1.7.6.5

