Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3EVDbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 23:31:45 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:28004 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3EVDbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 23:31:43 -0400
Message-ID: <519C3BD1.6050307@huawei.com>
Date: Wed, 22 May 2013 11:30:25 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, Li Zefan <lizefan@huawei.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v2] usb: omap2430: fix memleak in err case
References: <5192E650.3070303@huawei.com>
In-Reply-To: <5192E650.3070303@huawei.com>
X-Forwarded-Message-Id: <5192E650.3070303@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when omap_get_control_dev faild, we should release related platform_device

* Changelog from v1:
	* fix spell: s/fail/fails/, s/relational/related/ , thank Sergei <sergei.shtylyov@cogentembedded.com>

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



