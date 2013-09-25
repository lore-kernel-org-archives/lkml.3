Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3IYAqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:46:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3IYAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Steve Cotton <steve@s.cotton.clara.co.uk>
Subject: [ 027/117] xhci: fix port BESL LPM capability checking
Date: Tue, 24 Sep 2013 17:18:13 -0700
Message-Id: <20130925001743.798271050@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit dcf06a036848b4e8e6c8220f2e00b9adf6f84918 upstream.

Wrong capability bit was checked for best effort service latency.
bit 20 indicate port is BESL LPM capable (BLC),
bit 19 is hardware LPM capable (HLC)

This patch should be backported to kernels as old as 3.11, that
contain the commit a558ccdcc71c7770c5e80c926a31cfe8a3892a09 "usb: xhci:
add USB2 Link power management BESL support"

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Steve Cotton <steve@s.cotton.clara.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ext-caps.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ext-caps.h
+++ b/drivers/usb/host/xhci-ext-caps.h
@@ -71,7 +71,7 @@
 
 /* USB 2.0 xHCI 1.0 hardware LMP capability - section 7.2.2.1.3.2 */
 #define XHCI_HLC               (1 << 19)
-#define XHCI_BLC               (1 << 19)
+#define XHCI_BLC               (1 << 20)
 
 /* command register values to disable interrupts and halt the HC */
 /* start/stop HC execution - do not write unless HC is halted*/


