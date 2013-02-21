Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3BUId3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:33:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13522 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3BUId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:33:28 -0500
X-AuditID: cbfee691-b7f556d000001a24-f3-5125dbd66b1e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 02/12] rtc: rtc-tps6586x: use devm_request_threaded_irq()
Date: Thu, 21 Feb 2013 17:33:26 +0900
Message-id: <00cd01ce100e$1e4b21f0$5ae165d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAA83Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI93rt1UDDbbpW1zeNYfNgdHj8ya5
	AMYoLpuU1JzMstQifbsEroyJT1exF7RxVCw7Mp+5gfEaWxcjB4eEgInEhuXRXYycQKaYxIV7
	64HCXBxCAssYJXb8msYMkTCRWP3uMjNEYjqjxJkLj6Cc2UwSh7e9BatiE1CT+PLlMDvIVBEB
	fYm2Fg2QGmaBXqCG3t3sIDVCArYScz5cA6vnFLCTuLztCyuILSzgKfHq5CqwGhYBVYnfvb+Y
	QGxeoPqlzTfYIGxBiR+T77GA2MwCWhLrdx5ngrDlJTavAbkB5Bt1iUd/dUHCIgJGEpvmzmSE
	KBGR2PfiHSPIPRICy9glHt+5xwixS0Di2+RDLBC9shKbDkA9LClxcMUNlgmMErOQbJ6FZPMs
	JJtnIVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZIXE3cwXj/gPUhxmSg9ROZpUST
	84FxmVcSb2hsbGJmYmpibmlqbkqasJI4r/wlmUAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jDq6/lc6HvLs/MqabLHx08WDzx9YKbrOtTApMFKKt7+3W/nivvjl1esW8Dxfaz61xfHR5FsX
	U794J3wz/fZl16vJ63PaTWvf9s5bVj/3rpzbzvu1/IXayXlKcdO/qYTcUfg1eWPmxJ42gU3p
	iYYus+6Ubdg6i32tlVvv2l0XRNaUqJXdtpx0aIsSS3FGoqEWc1FxIgB7yDNfwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoO6126qBBjduWFpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjIlPV7EXtHFULDsyn7mB
	8RpbFyMnh4SAicTqd5eZIWwxiQv31gPFuTiEBKYzSpy58IgZwpnNJHF421uwKjYBNYkvXw6z
	dzFycIgI6Eu0tWiA1DAL9AI19O5mB6kRErCVmPPhGlg9p4CdxOVtX1hBbGEBT4lXJ1eB1bAI
	qEr87v3FBGLzAtUvbb7BBmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5DcgNHECXqks8+qsLEhYR
	MJLYNHcmI0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8
	dL3k/NxNjODIfSa9g3FVg8UhRgEORiUe3gUvVQKFWBPLiitzDzFKcDArifAqAuNeiDclsbIq
	tSg/vqg0J7X4EGMy0KMTmaVEk/OBSSWvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tS
	s1NTC1KLYLYwcXBKNTD25oblRrk/M/xy773qUy0eYbP/HqlK+3K/sWgeyV9rc8rl+cYvAk+5
	fj9X2Vt6UCNc2OucH++NjtX276dO3Rwx/VP8sTkrDxffDf/R+/xF5j2rNfmP4neGPXpn+I8t
	IDua67/NkS/7yl7OEEx87Ca/d+bM7A0xjv+PnF9/tOzWm/AY24tVVzf4K7EUZyQaajEXFScC
	AAw7TucgAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tps6586x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index 70f61b8..aab4e8c 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -282,7 +282,8 @@ static int tps6586x_rtc_probe(struct platform_device *pdev)
 		goto fail_rtc_register;
 	}
 
-	ret = request_threaded_irq(rtc->irq, NULL, tps6586x_rtc_irq,
+	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+				tps6586x_rtc_irq,
 				IRQF_ONESHOT | IRQF_EARLY_RESUME,
 				dev_name(&pdev->dev), rtc);
 	if (ret < 0) {
@@ -311,7 +312,6 @@ static int tps6586x_rtc_remove(struct platform_device *pdev)
 	tps6586x_update(tps_dev, RTC_CTRL, 0,
 		RTC_ENABLE | OSC_SRC_SEL | PRE_BYPASS | CL_SEL_MASK);
 	rtc_device_unregister(rtc->rtc);
-	free_irq(rtc->irq, rtc);
 	return 0;
 }
 
-- 
1.7.2.5


