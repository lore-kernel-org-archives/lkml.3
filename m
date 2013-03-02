Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3CBN1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:27:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12947 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3CBNZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:25 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-ff-5131fdc4aea2
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com
Subject: [PATCH v2 04/10] usb: dwc3: Add runtime power management callbacks
Date: Sat, 02 Mar 2013 18:53:05 +0530
Message-id: <1362230590-20960-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkWvfIX8NAg8aTihYH79dbNC9ez2bR
	u+Aqm8WFpz1sFpd3zWGzmL2kn8Vixvl9TBaLlrUyWzSfOMXswOkx72Sgx/65a9g9+rasYvQ4
	fmM7k8fnTXIBrFFcNimpOZllqUX6dglcGU07N7IXTOeu+H38MmMD42bOLkZODgkBE4m+I11s
	ELaYxIV764FsLg4hgaWMEhPntrLCFE38PJEdIjGdUeJN1wkoZwqTxIEld8Ha2QR0JZre7mIE
	sUUEZCUOX/nNDFLELHCJUWLFii0sXYwcHMIC3hJTG2xAalgEVCW+n3rKDhLmFfCQ2L06E2KZ
	gsSb28+YQWxOAU+J6dc3gx0hBFTy595xsL0SAuvYJZZtn8UGMUdA4tvkQ2DjJYD2bjrADDFH
	UuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIDPvT/5717WC8ecD6EGMy
	0LiJzFKiyfnAuMkriTc0NjE3NTY1M7K0tDQlTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrx
	IUYmDk6pBsZZe1rkWf9/cqtiKNy8YvopueijbR9t9zwu/9Vodejzuwd+4r0/3Dqycm/0yThJ
	WnjcLZmgtO34TpFVsaFOMbffajjMCimT5Vzz0PPktomJIhM2sK1gMFnvb9A+ewLvypvOkgHn
	P+4LWvZyWdvzHfWMrxV6g3T32NTeM9n6OTLGfsqkiGsef3SVWIozEg21mIuKEwFUyBXtkQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd0jfw0DDb7NlbQ4eL/eonnxejaL
	3gVX2SwuPO1hs7i8aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB06PeScDPfbPXcPu0bdlFaPH
	8RvbmTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jRtHMje8F0
	7orfxy8zNjBu5uxi5OSQEDCRmPh5IjuELSZx4d56ti5GLg4hgemMEm+6TrBDOFOYJA4sucsG
	UsUmoCvR9HYXI4gtIiArcfjKb2aQImaBS4wSK1ZsYeli5OAQFvCWmNpgA1LDIqAq8f3UU3aQ
	MK+Ah8Tu1ZkQyxQk3tx+xgxicwp4Sky/vpkVxBYCKvlz7zj7BEbeBYwMqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGCo+qZ9A7GVQ0WhxgFOBiVeHgDPhoECrEmlhVX5h5ilOBgVhLhPX/V
	MFCINyWxsiq1KD++qDQntfgQYzLQUROZpUST84ERn1cSb2hsYm5qbGppYmFiZkmasJI4L+Op
	JwFCAumJJanZqakFqUUwW5g4OKUaGNuf7loUtMr6is405/vfq8o6Wp0XvdusdD2oe8PrmpUv
	PrlalDlZefyxnJDCZPu/s2Qur13f7r83J6lcjdh3Xr6pzatIOas5Y2XQRYMJrB6Pg7411U7t
	WRSuZVeh4aUbzD8902n7KoaQkFaFq6wa85Ki39+Zm1ZRfOgq/5f4zImswoGcb8vclViKMxIN
	tZiLihMBCgbEbe4CAAA=
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
 drivers/usb/dwc3/core.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 2a77327..45e1aae 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -704,11 +704,38 @@ static int dwc3_resume(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int dwc3_runtime_suspend(struct device *dev)
+{
+	struct dwc3	*dwc = dev_get_drvdata(dev);
+
+	usb_phy_autopm_put_sync(dwc->usb2_phy);
+	usb_phy_autopm_put_sync(dwc->usb3_phy);
+
+	return 0;
+}
+
+static int dwc3_runtime_resume(struct device *dev)
+{
+	struct dwc3	*dwc = dev_get_drvdata(dev);
+
+	usb_phy_autopm_get_sync(dwc->usb2_phy);
+	usb_phy_autopm_get_sync(dwc->usb3_phy);
+
+	return 0;
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

