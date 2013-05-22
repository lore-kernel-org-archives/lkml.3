Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab3EVWMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:12:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3EVWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: [ 19/21] ntb_netdev: remove from list on exit
Date: Wed, 22 May 2013 15:10:37 -0700
Message-Id: <20130522205234.847841053@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Mason <jon.mason@intel.com>

commit 904435cf76a9bdd5eb41b1c4e049d5a64f3a8400 upstream.

The ntb_netdev device is not removed from the global list of devices
upon device removal.  If the device is re-added, the removal code would
find the first instance and try to remove an already removed device.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ntb_netdev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -375,6 +375,8 @@ static void ntb_netdev_remove(struct pci
 	if (dev == NULL)
 		return;
 
+	list_del(&dev->list);
+
 	ndev = dev->ndev;
 
 	unregister_netdev(ndev);


