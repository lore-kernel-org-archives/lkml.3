Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbaJVMCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:02:08 -0400
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:46617 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933003AbaJVMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:02:05 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: Kconfig: fix config COMEDI_ADDI_APCI_3120 dependants
Date: Wed, 22 Oct 2014 13:01:47 +0100
Message-Id: <1413979307-5681-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A merge conflict between commits
fbfd9c8a1782f33d7b67294b2a42587063e61c0c ("staging: comedi:
addi_apci_3120: use dma_alloc_coherent()") and
aff5b1f8eb71b64bb613dc64c50b6904e89f79b9 ("staging: comedi: remove
comedi_fc module") left the COMEDI_ADDI_APCI_3120 config option
depending on VIRT_TO_BUS when it no longer needs to do so.  The
dependency was removed by the first commit and accidentally reinstated
by the second commit.  Remove the dependency again.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index a8bc2b5..26e228f 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -667,7 +667,6 @@ config COMEDI_ADDI_APCI_2200
 config COMEDI_ADDI_APCI_3120
 	tristate "ADDI-DATA APCI_3120/3001 support"
 	depends on HAS_DMA
-	depends on VIRT_TO_BUS
 	---help---
 	  Enable support for ADDI-DATA APCI_3120/3001 cards
 
-- 
2.1.1

