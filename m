Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaGPKZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:25:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34377 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621AbaGPKXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:10 -0400
X-AuditID: cbfee61a-f79e46d00000134f-8b-53c6528c6e42
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 07/12] usb: dwc2/gadget: break infinite loop in endpoint
 disable code
Date: Wed, 16 Jul 2014 12:22:25 +0200
Message-id: <1405506150-16185-8-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd2eoGPBBjdf8VvMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKWHV1L1PBE9aKzocPmRsYn7B0MXJySAiYSHyZeYwJwhaT
	uHBvPVsXIxeHkMB0Roll2/azQjjtTBL/Wk+zgVSxCehIbPk+gRHEFhEQkFj/4hI7SBGzwAlG
	iY7/F8CKhAWiJD7t6WAGsVkEVCVa/v0Ha+AVcJWYvOwbG8Q6OYmTxyazgticAm4Sa143s4PY
	QkA1x9ctY5rAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCAPZPawbiyweIQowAH
	oxIP74aQo8FCrIllxZW5hxglOJiVRHgd/I8FC/GmJFZWpRblxxeV5qQWH2KU5mBREuc90God
	KCSQnliSmp2aWpBaBJNl4uCUamAstJ6RkHSk0/8al9Klr5HLLCfIG5kuPswZG3l3esHidw4z
	vb7d6Ki/uIXzoGT1tMzkq/Uviqf+OttbNbtU85gGZ/A6idD2M994/r9/Eh1vNDNt4nr18LUq
	M9uD9sRMPbBJZaVG5UVX4biKHFNDYyNz1wNs51akhy9usze/dkbO6b7/lI1XjK2UWIozEg21
	mIuKEwEIwXv4LAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch fixes possible freeze caused by infinite loop in interrupt
context.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 21d21de..2220882 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1652,6 +1652,7 @@ static void s3c_hsotg_txfifo_flush(struct s3c_hsotg *hsotg, unsigned int idx)
 			dev_err(hsotg->dev,
 				"%s: timeout flushing fifo (GRSTCTL=%08x)\n",
 				__func__, val);
+			break;
 		}
 
 		udelay(1);
-- 
1.9.1

