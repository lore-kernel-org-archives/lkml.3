Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab3LBVYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:24:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3LBTHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:07:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.4 43/60] prism54: set netdev type to "wlan"
Date: Mon,  2 Dec 2013 11:06:24 -0800
Message-Id: <20131202190339.667773262@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 8e3ffa471091c560deb6738ed9ab7445b7a5fd04 upstream.

Userspace uses the netdev devtype for stuff like device naming and type
detection.  Be nice and set it.  Remove the pointless #if/#endif around
SET_NETDEV_DEV too.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/prism54/islpci_dev.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -811,6 +811,10 @@ static const struct net_device_ops islpc
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+static struct device_type wlan_type = {
+	.name	= "wlan",
+};
+
 struct net_device *
 islpci_setup(struct pci_dev *pdev)
 {
@@ -821,9 +825,8 @@ islpci_setup(struct pci_dev *pdev)
 		return ndev;
 
 	pci_set_drvdata(pdev, ndev);
-#if defined(SET_NETDEV_DEV)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-#endif
+	SET_NETDEV_DEVTYPE(ndev, &wlan_type);
 
 	/* setup the structure members */
 	ndev->base_addr = pci_resource_start(pdev, 0);


