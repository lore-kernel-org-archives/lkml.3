Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3CBNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:25:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12941 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3CBNZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:23 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-f6-5131fdc2f257
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com
Subject: [PATCH v2 03/10] usb: dwc3: Enable runtime pm only after PHYs are
 initialized
Date: Sat, 02 Mar 2013 18:53:04 +0530
Message-id: <1362230590-20960-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkWvfQX8NAgxtT+S0O3q+3aF68ns2i
	d8FVNosLT3vYLC7vmsNmMXtJP4vFjPP7mCwWLWtltmg+cYrZgdNj3slAj/1z17B79G1Zxehx
	/MZ2Jo/Pm+QCWKO4bFJSczLLUov07RK4MjZ1XWYv+MhRsfLyT6YGxj3sXYwcHBICJhLLJ4d0
	MXICmWISF+6tZ+ti5OIQEljKKPFi1QVWiISJxIUtUxghEtMZJR4enssK4Uxhknj17QQjSBWb
	gK5E09tdYLaIgKzE4Su/mUGKmAUuMUqsWLGFBSQhLBAh8XfxB7DVLAKqEgcX14OEeQU8JD6e
	usgEsU1B4s3tZ8wgNqeAp8T065vBrhACqvlz7zg7yEwJgXXsEi+W94ElWAQEJL5NPsQC8Y6s
	xKYDzBBzJCUOrrjBMoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwLA//e9Z3w7G
	mwesDzEmA42byCwlmpwPjJu8knhDYxNzU2NTMyNLS0tT0oSVxHnlL8kECgmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamBku/N86b4VovueenmtNJZ2D1Xc9UfbXyRmQnn1bM4L5g4P92rOZhd7
	+jqsdvmeLw8YYi9F15koXv5z5fPZn2dSS1f+587d4iko06jBpCL1tvLxt/Iim1+HxHfr8om4
	eO14LbQ0LPns4qbXu27/5e+9eNDpfKFKwy2Oih1Cyaysj1gfBAZN/m6vxFKckWioxVxUnAgA
	HpNHaZECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd1Dfw0DDVb/ZLM4eL/eonnxejaL
	3gVX2SwuPO1hs7i8aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB06PeScDPfbPXcPu0bdlFaPH
	8RvbmTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixqesye8FH
	joqVl38yNTDuYe9i5OSQEDCRuLBlCiOELSZx4d56ti5GLg4hgemMEg8Pz2WFcKYwSbz6dgKs
	ik1AV6Lp7S4wW0RAVuLwld/MIEXMApcYJVas2MICkhAWiJD4u/gD0AoODhYBVYmDi+tBwrwC
	HhIfT11kgtimIPHm9jNmEJtTwFNi+vXNrCC2EFDNn3vH2Scw8i5gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERxXz6R3MK5qsDjEKMDBqMTDG/DRIFCINbGsuDL3EKMEB7OSCO/5q4aB
	QrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPjPm8knhDYxNzU2NTSxMLEzNL0oSVxHkZTz0J
	EBJITyxJzU5NLUgtgtnCxMEp1cC48OOSmXad4f5v28tzO53UfdWt/h1Pf+7Y8LYpN2W9F3eH
	eb7AWbtjh8+fmxjAFVhx+U/ilKbnks+dw+w6dk6YwBwx5+iF+OaSz15sJ1a91rTe/GZf5JmJ
	bibbVn5/VS67q9fIwKIsMGeekm3NQ4FLulO3Vd7UMvw8vefDs0XLJZ4KPZeY4PxdiaU4I9FQ
	i7moOBEAITLnCO8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow dwc3 to enable auto power management only after its PHYs
are initialized so that any further PHY handling by dwc3's
runtime power management callbacks is fine.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 85914e0..2a77327 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -453,10 +453,6 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
 
-	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
-	pm_runtime_forbid(dev);
-
 	dwc3_cache_hwparams(dwc);
 
 	ret = dwc3_alloc_event_buffers(dwc, DWC3_EVENT_BUFFERS_SIZE);
@@ -478,6 +474,10 @@ static int dwc3_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
+	pm_runtime_forbid(dev);
+
 	if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
 		mode = DWC3_MODE_HOST;
 	else if (IS_ENABLED(CONFIG_USB_DWC3_GADGET))
-- 
1.7.6.5

