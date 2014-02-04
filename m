Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398AbaBDVzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:55:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933642AbaBDVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.13 016/140] usb: dwc3: fix the glue drivers using the nop phy
Date: Tue,  4 Feb 2014 13:10:03 -0800
Message-Id: <20140204211037.430296131@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 13518673f1419f2667985a6fca4543e44143408b upstream.

The reset_gpio member of the usb_phy_gen_xceiv_platform_data
structure needs the have negative value or phy-generic's
probe will fail unless DT is used. 0 is a valid gpio number.

This fixes an issue where phy-generic fails to probe with
message: "usb_phy_gen_xceiv.0: Error requesting RESET GPIO 0".

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-exynos.c |    1 +
 drivers/usb/dwc3/dwc3-pci.c    |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -50,6 +50,7 @@ static int dwc3_exynos_register_phys(str
 
 	exynos->usb2_phy = pdev;
 	pdata.type = USB_PHY_TYPE_USB2;
+	pdata.gpio_reset = -1;
 
 	ret = platform_device_add_data(exynos->usb2_phy, &pdata, sizeof(pdata));
 	if (ret)
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -52,6 +52,7 @@ static int dwc3_pci_register_phys(struct
 
 	glue->usb2_phy = pdev;
 	pdata.type = USB_PHY_TYPE_USB2;
+	pdata.gpio_reset = -1;
 
 	ret = platform_device_add_data(glue->usb2_phy, &pdata, sizeof(pdata));
 	if (ret)


