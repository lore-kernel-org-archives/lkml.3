Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3CMNQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:16:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35719 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3CMNQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:16:11 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <rogerq@ti.com>
Subject: [PATCH 13/13] USB: ehci-omap: Get rid of omap_ehci_init()
Date: Wed, 13 Mar 2013 15:16:03 +0200
Message-ID: <1363180563-10658-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it does almost nothing, get rid of omap_ehci_init()
and move the ehci->caps initialization part into probe().

Also remove the outdated TODO list from header.

Signed-off-by: Roger Quadros <rogerq@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 755b428..5de3e43 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -29,12 +29,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
- * TODO (last updated Feb 27, 2010):
- *	- add kernel-doc
- *	- enable AUTOIDLE
- *	- add suspend/resume
- *	- add HSIC and TLL support
- *	- convert to use hwmod and runtime PM
  */
 
 #include <linux/kernel.h>
@@ -87,26 +81,12 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
 	return __raw_readl(base + reg);
 }
 
-static int omap_ehci_init(struct usb_hcd *hcd)
-{
-	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
-	int rc;
-
-	/* we know this is the memory we want, no need to ioremap again */
-	ehci->caps = hcd->regs;
-
-	rc = ehci_setup(hcd);
-
-	return rc;
-}
-
 /* configure so an HC device and id are always provided */
 /* always called with process context; sleeping is OK */
 
 static struct hc_driver __read_mostly ehci_omap_hc_driver;
 
 static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
-	.reset = omap_ehci_init,
 	.extra_priv_size = sizeof(struct omap_hcd),
 };
 
@@ -179,6 +159,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
+	hcd_to_ehci(hcd)->caps = regs;
 
 	omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
 	omap->nports = pdata->nports;
-- 
1.7.4.1

