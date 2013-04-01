Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab3DAJrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:47:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58400 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3DAJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:47:45 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-4b-515957c01f13
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 17/27] rtc: rtc-pcf2123: use devm_*() functions
Date: Mon, 01 Apr 2013 18:47:43 +0900
Message-id: <001c01ce2ebd$f541a620$dfc4f260$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAMEog
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfd0D4ZGBBne3c1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMWHvU+aCUzwVCx8+ZWxgnMrVxcjJISFgInGjdx8bhC0mceHeeiCbi0NIYBmjRPO5
	eywwRTv2nGKGSExnlPh49COU84tR4mjzcUaQKjYBNYkvXw6zdzFycIgI6Eu0tWiA1DAL9DJK
	nOndzQ5SIyRgK/Hj7HdmEJtTwE7izcJ5YL3CAvYSi7tfg9ksAqoSs3acBqvnBarfPPM5E4Qt
	KPFjMsRFzAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkcSDp2vYIUpEJPa9eMcIco+E
	wCN2iWf9a1kgdglIfJt8iAWiV1Zi0wFmiIclJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxi
	FE0tSC4oTkovMtYrTswtLs1L10vOz93ECInV/h2Mdw9YH2JMBlo/kVlKNDkfGOt5JfGGxmZG
	FqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCs/zpd3Nhx6vTk
	TZ03OHK5pTkPfnTPDXmo1VMy012q5o0gz1n1S7I3W6eW/X8U6521IeNv+2mZ48v9dmkezxKr
	m3D+6MqFh24trJn401FynyPLsouhqf6HFXKYPPM9PaJ3HWO8Oi/9eLm0sXsdUwx3q/MT6San
	SBPDS0mnP+WFn2/31o1+/1mJpTgj0VCLuag4EQBCk5XR6wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd0D4ZGBBq86WC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJiw9ylzwSmeioUPnzI2ME7l6mLk5JAQMJHY
	secUM4QtJnHh3nq2LkYuDiGB6YwSH49+ZIZwfjFKHG0+zghSxSagJvHly2H2LkYODhEBfYm2
	Fg2QGmaBXkaJM7272UFqhARsJX6c/Q42lVPATuLNwnlgvcIC9hKLu1+D2SwCqhKzdpwGq+cF
	qt888zkThC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYRMJJ48HQNO0SJ
	iMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBE
	8Ex6B+OqBotDjAIcjEo8vBEXIgKFWBPLiitzDzFKcDArifD6fAMK8aYkVlalFuXHF5XmpBYf
	YkwGenQis5Rocj4wSeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsT
	B6dUA+NMiaL9mXwbpcOCVqlcP+R4hvmiZl2C5QzNVf8cbZ7vqX70tXDarM3xuTtelb03T/xl
	oLHylNfZ7PNbp2cybcmQFjv88LyX8Y+VJSYZG34f+b34//Vr17uZJcVjHhZdVvv7cuVJnR0L
	3kkt2D3r8t08xdSN+nMEFFw5ElRe65pftdvHocJbf2GBEktxRqKhFnNRcSIAJhxbXkgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcf2123.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 02b742a..6a3f329 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -226,7 +226,8 @@ static int pcf2123_probe(struct spi_device *spi)
 	u8 txbuf[2], rxbuf[2];
 	int ret, i;
 
-	pdata = kzalloc(sizeof(struct pcf2123_plat_data), GFP_KERNEL);
+	pdata = devm_kzalloc(&spi->dev, sizeof(struct pcf2123_plat_data),
+				GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 	spi->dev.platform_data = pdata;
@@ -281,7 +282,7 @@ static int pcf2123_probe(struct spi_device *spi)
 	pcf2123_delay_trec();
 
 	/* Finalize the initialization */
-	rtc = rtc_device_register(pcf2123_driver.driver.name, &spi->dev,
+	rtc = devm_rtc_device_register(&spi->dev, pcf2123_driver.driver.name,
 			&pcf2123_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
@@ -314,7 +315,6 @@ sysfs_exit:
 		device_remove_file(&spi->dev, &pdata->regs[i].attr);
 
 kfree_exit:
-	kfree(pdata);
 	spi->dev.platform_data = NULL;
 	return ret;
 }
@@ -325,15 +325,10 @@ static int pcf2123_remove(struct spi_device *spi)
 	int i;
 
 	if (pdata) {
-		struct rtc_device *rtc = pdata->rtc;
-
-		if (rtc)
-			rtc_device_unregister(rtc);
 		for (i = 0; i < 16; i++)
 			if (pdata->regs[i].name[0])
 				device_remove_file(&spi->dev,
 						   &pdata->regs[i].attr);
-		kfree(pdata);
 	}
 
 	return 0;
-- 
1.7.2.5


