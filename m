Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3CMJCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:02:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29028 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3CMJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:02:34 -0400
X-AuditID: cbfee68e-b7f946d000001e37-65-514040a7d478
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, cw00.choi@samsung.com
Subject: [PATCH 1/3] extcon: max8997: Check the pointer of platform data to
 protect null pointer error
Date: Wed, 13 Mar 2013 18:02:16 +0900
Message-id: <1363165338-989-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1363165338-989-1-git-send-email-cw00.choi@samsung.com>
References: <1363165338-989-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t8zXd3lDg6BBvv3K1hc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUVw2Kak5mWWpRfp2CVwZnbsa2AueiFc8WifTwHhR
	uIuRk0NCwERicu90ZghbTOLCvfVsXYxcHEICyxglZm16xwJTdPJYM1RiOqPEnYkL2SGc/4wS
	S649B6tiE9CS2P/iBhuILSKgILG59xkriM0s4CfxZvNXxi5GDg5hgQyJk10eIGEWAVWJiXda
	GEFsXgFnia3Hl7JCLJOT+LDnETtIOaeAi8SBC+UgYSGgkuU3f7GArJUQeM8m0bV2JSvEHAGJ
	b5MPsYDUSwjISmw6APWMpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kpFecmFtcmpeul5yfu4kR
	EqZ9OxhvHrA+xJgMNG4is5Rocj4wzPNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwKi9tXlKooPAB+7punLnJITTOw57hfpLXVJOeeX1LnqiZkrF
	Tf8JUncezVo/67w+X0lP+JuQabvf3Vkbz7Fjbsm+I1O9VuUKWDzNK7yU7/Pym6FbV8DmN6xr
	Zk3IDHdXfjXb6KyyunzbCr8fXhcaFk44/EYo94Ha+f9lffcvrI75cvnBgt1/c64rsRRnJBpq
	MRcVJwIA7Aj/GmkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQd3lDg6BBot3SFtc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGZ27GtgLnohXPFon08B4UbiLkZNDQsBE4uSxZjYIW0ziwr31QDYXh5DAdEaJOxMX
	skM4/xklllx7zgJSxSagJbH/xQ2wDhEBBYnNvc9YQWxmAT+JN5u/MnYxcnAIC2RInOzyAAmz
	CKhKTLzTwghi8wo4S2w9vpQVYpmcxIc9j9hByjkFXCQOXCgHCQsBlSy/+YtlAiPvAkaGVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxjBUfBMegfjqgaLQ4wCHIxKPLwSafaBQqyJZcWVuYcY
	JTiYlUR4v9k4BArxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjBC80riDY1NzIwsjcyMTcyN
	jUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBce27139Pvvrm1fT1Jb9M6Yer2cxz05Vq
	Nx7dF7To6XmP8Obz8Yo8nQKn3kvvnfBuxvOfX1uZO1adFIvQKHus5R71J4k58Ot+7WXHlB5E
	3y58x2osrGEV8OB+++lqb+FJlqvmZLf8NS2VnD138xmVWl5RbTt7nQun4hKOZpzzeni3tG31
	8vt9EUosxRmJhlrMRcWJAFWuQQvGAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch check the pointer of platform data to protect
kernel panic when platform data is not used and code clean.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max8997.c | 56 +++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index e636d95..69641bc 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -712,29 +712,45 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	/* Initialize registers according to platform data */
 	if (pdata->muic_pdata) {
-		struct max8997_muic_platform_data *mdata = info->muic_pdata;
-
-		for (i = 0; i < mdata->num_init_data; i++) {
-			max8997_write_reg(info->muic, mdata->init_data[i].addr,
-					mdata->init_data[i].data);
+		struct max8997_muic_platform_data *muic_pdata
+			= pdata->muic_pdata;
+
+		/* Initialize registers according to platform data */
+		for (i = 0; i < muic_pdata->num_init_data; i++) {
+			max8997_write_reg(info->muic,
+					muic_pdata->init_data[i].addr,
+					muic_pdata->init_data[i].data);
 		}
-	}
 
-	/*
-	 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
-	 * h/w path of COMP2/COMN1 on CONTROL1 register.
-	 */
-	if (pdata->muic_pdata->path_uart)
-		info->path_uart = pdata->muic_pdata->path_uart;
-	else
-		info->path_uart = CONTROL1_SW_UART;
+		/*
+		 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
+		 * h/w path of COMP2/COMN1 on CONTROL1 register.
+		 */
+		if (muic_pdata->path_uart)
+			info->path_uart = muic_pdata->path_uart;
+		else
+			info->path_uart = CONTROL1_SW_UART;
 
-	if (pdata->muic_pdata->path_usb)
-		info->path_usb = pdata->muic_pdata->path_usb;
-	else
+		if (muic_pdata->path_usb)
+			info->path_usb = muic_pdata->path_usb;
+		else
+			info->path_usb = CONTROL1_SW_USB;
+
+		/*
+		 * Default delay time for detecting cable state
+		 * after certain time.
+		 */
+		if (muic_pdata->detcable_delay_ms)
+			delay_jiffies =
+				msecs_to_jiffies(muic_pdata->detcable_delay_ms);
+		else
+			delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
+	} else {
+		info->path_uart = CONTROL1_SW_UART;
 		info->path_usb = CONTROL1_SW_USB;
+		delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
+	}
 
 	/* Set initial path for UART */
 	 max8997_muic_set_path(info, info->path_uart, true);
@@ -751,10 +767,6 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	 * driver should notify cable state to upper layer.
 	 */
 	INIT_DELAYED_WORK(&info->wq_detcable, max8997_muic_detect_cable_wq);
-	if (pdata->muic_pdata->detcable_delay_ms)
-		delay_jiffies = msecs_to_jiffies(pdata->muic_pdata->detcable_delay_ms);
-	else
-		delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
 	schedule_delayed_work(&info->wq_detcable, delay_jiffies);
 
 	return 0;
-- 
1.8.0

