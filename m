Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbaJaRsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:48:05 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:40388 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbaJaRsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:48:02 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] staging: comedi: comedidev.h: remove some #ifdefs
Date: Fri, 31 Oct 2014 17:47:36 +0000
Message-Id: <1414777659-25578-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some declarations and macro definitions in "comedidev.h" are protected
by various `#ifdef`s for kernel configuration options, but the header
file compiles fine without the `#ifdef`s regardless of whether those
config option macros are defined or not.  Remove the `#ifdef`s and
compile the affected code unconditionally.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 5788b38..a39db7c 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -562,8 +562,6 @@ void comedi_driver_unregister(struct comedi_driver *);
 	module_driver(__comedi_driver, comedi_driver_register, \
 			comedi_driver_unregister)
 
-#ifdef CONFIG_COMEDI_PCI_DRIVERS
-
 /* comedi_pci.c - comedi PCI driver specific functions */
 
 /*
@@ -607,10 +605,6 @@ void comedi_pci_driver_unregister(struct comedi_driver *, struct pci_driver *);
 	module_driver(__comedi_driver, comedi_pci_driver_register, \
 			comedi_pci_driver_unregister, &(__pci_driver))
 
-#endif /* CONFIG_COMEDI_PCI_DRIVERS */
-
-#ifdef CONFIG_COMEDI_PCMCIA_DRIVERS
-
 /* comedi_pcmcia.c - comedi PCMCIA driver specific functions */
 
 struct pcmcia_driver;
@@ -644,10 +638,6 @@ void comedi_pcmcia_driver_unregister(struct comedi_driver *,
 	module_driver(__comedi_driver, comedi_pcmcia_driver_register, \
 			comedi_pcmcia_driver_unregister, &(__pcmcia_driver))
 
-#endif /* CONFIG_COMEDI_PCMCIA_DRIVERS */
-
-#ifdef CONFIG_COMEDI_USB_DRIVERS
-
 /* comedi_usb.c - comedi USB driver specific functions */
 
 struct usb_driver;
@@ -677,6 +667,4 @@ void comedi_usb_driver_unregister(struct comedi_driver *, struct usb_driver *);
 	module_driver(__comedi_driver, comedi_usb_driver_register, \
 			comedi_usb_driver_unregister, &(__usb_driver))
 
-#endif /* CONFIG_COMEDI_USB_DRIVERS */
-
 #endif /* _COMEDIDEV_H */
-- 
2.1.1

