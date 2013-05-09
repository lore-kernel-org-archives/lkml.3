Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab3EIFBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:01:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50340 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3EIFBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:01:30 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <stern@rowland.harvard.edu>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>,
        Libo Chen <chenlibo.3@gmail.com>, Libo Chen <libo.chen@huawei.com>
Subject: [PATCH 1/4] usb: ehci-s5p: fix memleak when fallback to pdata
Date: Thu, 9 May 2013 12:58:08 +0800
Message-ID: <1368075491-38728-2-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
References: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <chenlibo.3@gmail.com>

When devm_usb_get_phy fail, we should free hcd

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/ehci-s5p.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 6357752..3fbab58 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -107,6 +107,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	if (IS_ERR(phy)) {
 		/* Fallback to pdata */
 		if (!pdata) {
+			usb_put_hcd(hcd);
 			dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
 			return -EPROBE_DEFER;
 		} else {
-- 
1.7.1


