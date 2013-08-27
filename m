Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3H0DIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:08:35 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:41995 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3H0DIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:08:34 -0400
Message-ID: <521C181B.8040307@huawei.com>
Date: Tue, 27 Aug 2013 11:08:11 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
CC: USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] usb: ohci-at91: remove unnecessary dev_set_drvdata()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/ohci-at91.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 9677f68..b49a6c8 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -216,8 +216,6 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 	clk_put(fclk);
 	clk_put(iclk);
 	fclk = iclk = hclk = NULL;
-
-	dev_set_drvdata(&pdev->dev, NULL);
 }

 /*-------------------------------------------------------------------------*/
-- 
1.7.1

