Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3H3DYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:24:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26689 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3H3DYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:24:00 -0400
Message-ID: <52201034.7010609@huawei.com>
Date: Fri, 30 Aug 2013 11:23:32 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <swarren@wwwdotorg.org>, USB <linux-usb@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 3/4] usb: phy-tegra-usb: use platform_{get,set}_drvdata()
References: <521C5EF3.2090907@huawei.com> <20130828043616.GB21756@kroah.com>
In-Reply-To: <20130828043616.GB21756@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &of->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/phy/phy-tegra-usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

rebase on usb-next tree

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 3bfb3d1..e9cb1cb 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -1064,7 +1064,7 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 	tegra_phy->u_phy.shutdown = tegra_usb_phy_close;
 	tegra_phy->u_phy.set_suspend = tegra_usb_phy_suspend;

-	dev_set_drvdata(&pdev->dev, tegra_phy);
+	platform_set_drvdata(pdev, tegra_phy);

 	err = usb_add_phy_dev(&tegra_phy->u_phy);
 	if (err < 0) {
-- 
1.7.1


