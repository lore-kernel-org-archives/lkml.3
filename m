Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3JUIuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39369 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753376Ab3JUIus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.874399361@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 037/149] USB: OHCI: Allow runtime PM without system sleep
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ohci-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -413,7 +413,7 @@ static struct pci_driver ohci_pci_driver
 	.remove =	usb_hcd_pci_remove,
 	.shutdown =	usb_hcd_pci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},

