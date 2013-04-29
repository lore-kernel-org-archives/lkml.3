Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab3D2Ppi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:45:38 -0400
Received: from mx1.sisa.samsung.com ([63.166.156.249]:42351 "EHLO
	mx1.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab3D2Ppg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:45:36 -0400
X-ASG-Debug-ID: 1367250335-05c032381c33230001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: "marcel@holtmann.org" <marcel@holtmann.org>,
        "gustavo@padovan.org" <gustavo@padovan.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: [PATCH] Bluetooth: Add missing reset_resume dev_pm_ops
Thread-Topic: [PATCH] Bluetooth: Add missing reset_resume dev_pm_ops
X-ASG-Orig-Subj: [PATCH] Bluetooth: Add missing reset_resume dev_pm_ops
Thread-Index: AQHORPCWYn5rgwEVikOQkuKYXOoztw==
Date: Mon, 29 Apr 2013 15:45:34 +0000
Message-ID: <1367250333.4938.20.camel@lorien>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7206D76F875C2149B825999050E17075@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: webmail.sisa.samsung.com[105.144.21.115]
X-Barracuda-Start-Time: 1367250335
X-Barracuda-URL: http://192.168.0.101:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3TFjhTg016053

Add missing reset_resume dev_pm_ops. Missing reset_resume results in the
following message after power management device test. This change sets
reset_resume to btusb_resume().

[ 2506.936134] btusb 1-1.5:1.0: no reset_resume for driver btusb?
[ 2506.936137] btusb 1-1.5:1.1: no reset_resume for driver btusb?

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/bluetooth/btusb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2cc5f77..11d72de 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1230,6 +1230,7 @@ static struct usb_driver btusb_driver = {
 #ifdef CONFIG_PM
 	.suspend	= btusb_suspend,
 	.resume		= btusb_resume,
+	.reset_resume	= btusb_resume,
 #endif
 	.id_table	= btusb_table,
 	.supports_autosuspend = 1,
-- 
1.7.10.4


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
