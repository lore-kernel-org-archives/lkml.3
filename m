Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163Ab3GWWXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:23:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52407 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852Ab3GWWXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:23:54 -0400
Message-ID: <51EF0243.1000007@infradead.org>
Date: Tue, 23 Jul 2013 15:22:59 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: [PATCH] usb: fix build warning in pci-quirks.h when CONFIG_PCI is
 not enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix warning when CONFIG_PCI is not enabled
(from commit 296365781903226a3fb8758901eaeec09d2798e4).

drivers/usb/host/pci-quirks.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Moiz Sonasath <m-sonasath@ti.com>
---
 drivers/usb/host/pci-quirks.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-311-rc2.orig/drivers/usb/host/pci-quirks.h
+++ lnx-311-rc2/drivers/usb/host/pci-quirks.h
@@ -13,6 +13,7 @@ void usb_enable_xhci_ports(struct pci_de
 void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
 void sb800_prefetch(struct device *dev, int on);
 #else
+struct pci_dev;
 static inline void usb_amd_quirk_pll_disable(void) {}
 static inline void usb_amd_quirk_pll_enable(void) {}
 static inline void usb_amd_dev_put(void) {}
