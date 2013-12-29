Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3L2CPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:15:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55827 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533Ab3L2CNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:13:18 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Williams" <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.63791474@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 052/185] prism54: set netdev type to "wlan"
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 8e3ffa471091c560deb6738ed9ab7445b7a5fd04 upstream.

Userspace uses the netdev devtype for stuff like device naming and type
detection.  Be nice and set it.  Remove the pointless #if/#endif around
SET_NETDEV_DEV too.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/prism54/islpci_dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -812,6 +812,10 @@ static const struct net_device_ops islpc
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+static struct device_type wlan_type = {
+	.name	= "wlan",
+};
+
 struct net_device *
 islpci_setup(struct pci_dev *pdev)
 {
@@ -822,9 +826,8 @@ islpci_setup(struct pci_dev *pdev)
 		return ndev;
 
 	pci_set_drvdata(pdev, ndev);
-#if defined(SET_NETDEV_DEV)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-#endif
+	SET_NETDEV_DEVTYPE(ndev, &wlan_type);
 
 	/* setup the structure members */
 	ndev->base_addr = pci_resource_start(pdev, 0);

