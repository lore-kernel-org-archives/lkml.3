Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3C1Vz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:55:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52499 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3C1Vyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:54:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 4/7] USB: EHCI: export ehci_shutdown
Date: Thu, 28 Mar 2013 22:55:02 +0100
Message-Id: <1364507705-22012-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364507705-22012-1-git-send-email-arnd@arndb.de>
References: <1364507705-22012-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:47JRbsCpr0hbUwh+rVdSmDMjnQO1yPPfNQnVXzJb4Fy
 wtOn+T0i4OmVV3d3PYM7jCqXzfHP7FuQE+fkQX6nWL1uStRjxL
 TEKujv5O1qP2di6o+Qnr7UWReWVIDEuwbtKEW2c4NajXY731ii
 xgGrEG4poPJ3GyWuMdp0C4+HVL7G3I3v8PFkN63GLfyzG41ceG
 l1jn3GiUoE24I1vb8o1QHF7n6CoMF/6JsoLNI9AM6+boJ7SbI/
 Ah3jJ1IC6x8XUI8JE63A5oaY1nrHKFPYZADMcB+XNZaPtotZi9
 6xAKZVd0qz8RuRFme8GWozhdmu3lzwHxPJ6Cgf/66hbXdYgqlS
 Jb6qVZH7E4+rZuh3/ZdCethA3CC2qasjtYF/t1/OQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ehci_shutdown function is used by the platform specific ehci backends
for at91, tegra and ps3. In order to turn any of these into separate
modules, we need to make this function globally visible and export it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/ehci-hcd.c | 3 ++-
 drivers/usb/host/ehci.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 8f1f4b4..1c9aa17 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -353,7 +353,7 @@ static void ehci_silence_controller(struct ehci_hcd *ehci)
  * This forcibly disables dma and IRQs, helping kexec and other cases
  * where the next system software may expect clean state.
  */
-static void ehci_shutdown(struct usb_hcd *hcd)
+void ehci_shutdown(struct usb_hcd *hcd)
 {
 	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
 
@@ -367,6 +367,7 @@ static void ehci_shutdown(struct usb_hcd *hcd)
 
 	hrtimer_cancel(&ehci->hrtimer);
 }
+EXPORT_SYMBOL_GPL(ehci_shutdown);
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index e666999..915739d 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -799,6 +799,7 @@ struct ehci_driver_overrides {
 extern void	ehci_init_driver(struct hc_driver *drv,
 				const struct ehci_driver_overrides *over);
 extern int	ehci_setup(struct usb_hcd *hcd);
+extern void	ehci_shutdown(struct usb_hcd *hcd);
 
 #ifdef CONFIG_PM
 extern int	ehci_suspend(struct usb_hcd *hcd, bool do_wakeup);
-- 
1.8.1.2

