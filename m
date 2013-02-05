Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3BENjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:39:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11168 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3BENjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:39:39 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-c4-51110b9af8d1
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kishon@ti.com
Subject: [PATCH RFC] usb: dwc3: Set GCTL.PrtCapDir based on selected mode.
Date: Tue, 05 Feb 2013 19:15:58 +0530
Message-id: <1360071958-20797-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkVncWt2Cgwa7rbBaXd81hs5i9pJ/F
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4Mn59zy+Ywlsx9cY75gbGp1xdjBwcEgImEo0N
	pl2MnECmmMSFe+vZuhi5OIQEljJKdHz/xQxTc/W8DkiNkMB0Rok5ryQh7MlMEjdPcIHYbAK6
	Ek1vdzGC2CICshKHr/xmBrGZBcolVs/cwwpiCwt4Sfx8eIAVZCSLgKrEipWVIGFeAQ+JzZu7
	WCFOUJB4c/sZM8gJEgJH2CT+Np5nAkmwCAhIfJt8iAXiHFmJTQeYIeolJQ6uuMEygVFwASPD
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzA4Dr975n0DsZVDRaHGAU4GJV4eH9c5g8UYk0s
	K67MPcQowcGsJMJb/UUgUIg3JbGyKrUoP76oNCe1+BBjMtDyicxSosn5wMDPK4k3NDYxNzU2
	tTQyMjM1JU1YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2MQWIOjcFfinjUlqUk/Hzh98V0
	5vwXtzSebDLbqcd2ZONk6TCFPytFzttm/1A4Whza1mgutNPdaaLmzOYHSXc0y+te9H3+a5rY
	I7g5Ou7uPfWm37FZkvOb5hx5v/3h0ywJG1vt+cr9jH2XOKuibt3vva472dt97bmPEUoHSg7U
	9KlEpHBPZ76jxFKckWioxVxUnAgAH62pInICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xoO5MbsFAg3VrzSwu75rDZjF7ST+L
	xaJlrcwOzB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
	2iq5+AToumXmAM1XUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGb8+p5f
	MIW3YuqNd8wNjE+5uhg5OCQETCSuntfpYuQEMsUkLtxbzwZiCwlMZ5SY80oSwp7MJHHzBBeI
	zSagK9H0dhcjiC0iICtx+MpvZhCbWaBcYvXMPawgtrCAl8TPhwdYQcazCKhKrFhZCRLmFfCQ
	2Ly5ixVilYLEm9vPmCcwci9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERy8z6R3MK5q
	sDjEKMDBqMTD++Myf6AQa2JZcWXuIUYJDmYlEd7qLwKBQrwpiZVVqUX58UWlOanFhxiTgZZP
	ZJYSTc4HRlZeSbyhsYm5qbGppYmFiZklacJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCUamCc
	ckZ+v3KZRP1FlvexgsLSVQvlE9tffPxoZGAxbe/rQxeTr+SdrtvG9Epqxta7Xw4HqhwTELXe
	c+nsnkPuR+o+3XfW1OZJMzM+9OfN2+hSuwNOF0w+sL+fmLpY563iH/eAjJsvtCbJ8i6T9j0e
	oiPZpLhrPvvClhX8GctMNGyiwoMM5+j0lf9TYinOSDTUYi4qTgQAFlKqVKICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that machines may select the mode of working of DWC3,
we can set the Port capability direction based on selected mode.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/core.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 177f4c6..f4c47f7 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -479,7 +479,6 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	switch (mode) {
 	case DWC3_MODE_DEVICE:
-		dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
 		ret = dwc3_gadget_init(dwc);
 		if (ret) {
 			dev_err(dev, "failed to initialize gadget\n");
@@ -487,7 +486,6 @@ static int dwc3_probe(struct platform_device *pdev)
 		}
 		break;
 	case DWC3_MODE_HOST:
-		dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_HOST);
 		ret = dwc3_host_init(dwc);
 		if (ret) {
 			dev_err(dev, "failed to initialize host\n");
@@ -495,7 +493,6 @@ static int dwc3_probe(struct platform_device *pdev)
 		}
 		break;
 	case DWC3_MODE_DRD:
-		dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
 		ret = dwc3_host_init(dwc);
 		if (ret) {
 			dev_err(dev, "failed to initialize host\n");
@@ -514,6 +511,14 @@ static int dwc3_probe(struct platform_device *pdev)
 	}
 	dwc->mode = mode;
 
+#if IS_ENABLED(CONFIG_USB_DWC3_HOST)
+	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_HOST);
+#elif IS_ENABLED(CONFIG_USB_DWC3_GADGET)
+	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
+#else
+	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
+#endif
+
 	ret = dwc3_debugfs_init(dwc);
 	if (ret) {
 		dev_err(dev, "failed to initialize debugfs\n");
-- 
1.7.6.5

