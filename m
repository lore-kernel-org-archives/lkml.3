Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3ELV4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 17:56:10 -0400
Received: from mout.gmx.net ([212.227.15.18]:65492 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3ELV4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 17:56:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX184WBI7GFw4aGAk/Un0B1ALrnOv57hPJ/uTttFU3v
	n4dWwYXUk3KvmS
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/comedi: Add VIRT_TO_BUS dependency to 'fix' build failure
Date: Mon, 13 May 2013 00:00:39 +0200
Message-Id: <1368396039-9249-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the platform does not provide virt_to_bus the ni_labpc.c driver fails to
compile.
In order not to break these builds we have to add a depends on
CONFIG_VIRT_TO_BUS to the affected drivers.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 7871579..76ccb90 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1024,6 +1024,7 @@ config COMEDI_NI_LABPC_PCI
 	tristate "NI Lab-PC PCI-1200 support"
 	select COMEDI_NI_LABPC
 	select COMEDI_MITE
+	depends on VIRT_TO_BUS
 	---help---
 	  Enable support for National Instruments Lab-PC PCI-1200.
 
@@ -1151,6 +1152,7 @@ config COMEDI_NI_DAQ_DIO24_CS
 config COMEDI_NI_LABPC_CS
 	tristate "NI DAQCard-1200 PCMCIA support"
 	select COMEDI_NI_LABPC
+	depends on VIRT_TO_BUS
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQCard-1200
 
@@ -1267,6 +1269,7 @@ config COMEDI_NI_LABPC
 	tristate
 	select COMEDI_8255
 	select COMEDI_FC
+	depends on VIRT_TO_BUS
 
 config COMEDI_NI_TIO
 	tristate
-- 
1.8.1.5

