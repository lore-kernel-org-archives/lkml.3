Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaIIIwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:52:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51149 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaIIIoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:44:37 -0400
X-AuditID: cbfee61b-f79f86d00000144c-20-540ebdf38aa2
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 3/6] usb: dwc2/gadget: break infinite loop in endpoint disable
 code
Date: Tue, 09 Sep 2014 10:44:10 +0200
Message-id: <1410252253-13687-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
References: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t9jQd3Pe/lCDDr+mVgcvF9v0bx4PZvF
	5V1z2CwWLWtltlh75C67xaOHW1ktHhzeye7A7rF/7hp2j74tqxg9tuz/zOhx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4Mq68uc5e8IS1ovFYA3MD4xOWLkZODgkBE4nX308xQthiEhfurWfr
	YuTiEBKYziixvX8pC4TTziTxdf5ZVpAqNgEdiS3fJ4B1iAjIS1zfeBOsiFlgH6PE9E/b2EES
	wgKhElM77oOtYBFQlTi9ZhVYM6+Aq8Tcfz+YINbJSZw8NhkszingJjG/t58NxBYCqul8spZx
	AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBYfVMegfjqgaLQ4wCHIxKPLwZwXwh
	QqyJZcWVuYcYJTiYlUR4r+wGCvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2a
	WpBaBJNl4uCUamA0TttTf9AmRdrXS9X1c1nHdD5xNWXBKMOrJpNCel+EfAra/5mzIvtwidja
	LqaCc4oaqw6WOh8pzY29kxpTW8NfltbN/5R19641enuU2Oq7tuqZZ/8pvvtaQJptRvyXqKdz
	TY4uXdod93ld24pp0XtzY4rkDzP4PNL7zLfsl8W1N283n9BuFFRiKc5INNRiLipOBABgW1cV
	JwIAAA==
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
index fd556e0..a451eef 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1649,6 +1649,7 @@ static void s3c_hsotg_txfifo_flush(struct s3c_hsotg *hsotg, unsigned int idx)
 			dev_err(hsotg->dev,
 				"%s: timeout flushing fifo (GRSTCTL=%08x)\n",
 				__func__, val);
+			break;
 		}
 
 		udelay(1);
-- 
1.9.1

