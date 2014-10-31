Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbaJaRtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:49:13 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:48744 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757386AbaJaRsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:48:01 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] staging: comedi: comedidev.h: remove dummy PCI support functions
Date: Fri, 31 Oct 2014 17:47:35 +0000
Message-Id: <1414777659-25578-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some low-level Comedi driver modules used to handle PCI devices and ISA
devices in the same module with some conditional compilation.  To reduce
the amount of conditional compilation, some dummy inline versions of
`comedi_to_pci_dev()`, `comedi_pci_enable()`, `comedi_pci_disable()`,
and `comedi_pci_detach()` are defined in "comedidev.h" if
`CONFIG_COMEDI_PCI_DRIVERS` is undefined.  Since those Comedi low-level
driver modules have since had PCI support split out into separate
modules, there is no need to keep the dummy inline functions around any
more, so remove them.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index d18f702..5788b38 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -607,32 +607,6 @@ void comedi_pci_driver_unregister(struct comedi_driver *, struct pci_driver *);
 	module_driver(__comedi_driver, comedi_pci_driver_register, \
 			comedi_pci_driver_unregister, &(__pci_driver))
 
-#else
-
-/*
- * Some of the comedi mixed ISA/PCI drivers call the PCI specific
- * functions. Provide some dummy functions if CONFIG_COMEDI_PCI_DRIVERS
- * is not enabled.
- */
-
-static inline struct pci_dev *comedi_to_pci_dev(struct comedi_device *dev)
-{
-	return NULL;
-}
-
-static inline int comedi_pci_enable(struct comedi_device *dev)
-{
-	return -ENOSYS;
-}
-
-static inline void comedi_pci_disable(struct comedi_device *dev)
-{
-}
-
-static inline void comedi_pci_detach(struct comedi_device *dev)
-{
-}
-
 #endif /* CONFIG_COMEDI_PCI_DRIVERS */
 
 #ifdef CONFIG_COMEDI_PCMCIA_DRIVERS
-- 
2.1.1

