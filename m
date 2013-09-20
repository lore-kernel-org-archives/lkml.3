Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3ITUWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:22:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3ITUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 33/93] USB: OHCI: Allow runtime PM without system sleep
Date: Fri, 20 Sep 2013 13:08:28 -0700
Message-Id: <1379707768-1804-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 69820e01aa756b8d228143d997f71523c1e97984 upstream.

Since ohci-hcd supports runtime PM, the .pm field in its pci_driver
structure should be protected by CONFIG_PM rather than
CONFIG_PM_SLEEP.

Without this change, OHCI controllers won't do runtime suspend if
system suspend or hibernation isn't enabled.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ohci-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index 951514e..ef6782b 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -371,7 +371,7 @@ static struct pci_driver ohci_pci_driver = {
 	.remove =	usb_hcd_pci_remove,
 	.shutdown =	usb_hcd_pci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},
-- 
1.8.1.2

