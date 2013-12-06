Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422643Ab3LFNno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:43:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231Ab3LFNCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 134/272] prism54: set netdev type to "wlan"
Date: Fri,  6 Dec 2013 12:57:03 +0000
Message-Id: <1386334761-25517-135-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 8e3ffa471091c560deb6738ed9ab7445b7a5fd04 upstream.

Userspace uses the netdev devtype for stuff like device naming and type
detection.  Be nice and set it.  Remove the pointless #if/#endif around
SET_NETDEV_DEV too.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/prism54/islpci_dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 5970ff6..d498b02 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -811,6 +811,10 @@ static const struct net_device_ops islpci_netdev_ops = {
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
-- 
1.8.3.2

