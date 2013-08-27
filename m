Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3H0ILJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:11:09 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:48224 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab3H0ILG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:11:06 -0400
Message-ID: <521C5EF7.1040207@huawei.com>
Date: Tue, 27 Aug 2013 16:10:31 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <kuninori.morimoto.gx@renesas.com>,
        USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] usb: renesas_usbhs: use platform_{get,set}_drvdata()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/renesas_usbhs/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index cfd2050..b097aa3 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -499,7 +499,7 @@ static int usbhs_probe(struct platform_device *pdev)
 		goto probe_end_fifo_exit;

 	/* dev_set_drvdata should be called after usbhs_mod_init */
-	dev_set_drvdata(&pdev->dev, priv);
+	platform_set_drvdata(pdev, priv);

 	/*
 	 * deviece reset here because
-- 
1.7.1

