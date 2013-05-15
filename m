Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3EOBf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:35:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15481 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3EOBfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:35:55 -0400
Message-ID: <5192E650.3070303@huawei.com>
Date: Wed, 15 May 2013 09:35:12 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <grant.likely@linaro.org>, <rob.herring@calxeda.com>
CC: <linux-mips@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] usb: omap2430: fix memleak in err case
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when omap_get_control_dev fail, we should release relational platform_device

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/musb/omap2430.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 3551f1a..b626f19 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -549,7 +549,8 @@ static int omap2430_probe(struct platform_device *pdev)
 		glue->control_otghs = omap_get_control_dev();
 		if (IS_ERR(glue->control_otghs)) {
 			dev_vdbg(&pdev->dev, "Failed to get control device\n");
-			return -ENODEV;
+			ret = -ENODEV;
+			goto err2;
 		}
 	} else {
 		glue->control_otghs = ERR_PTR(-ENODEV);
-- 
1.7.1

