Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897Ab3E3QZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:25:08 -0400
Received: from mout.gmx.net ([212.227.17.21]:55428 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935531Ab3E3QYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:24:53 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18Ez1giJD4EE97hv8evOQQ1omX+MIeR371FuhkCHt
	kt1flKtGqU7ErO
Date: Thu, 30 May 2013 18:24:46 +0200
From: Helge Deller <deller@gmx.de>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] parport_pc: disable PARPORT_PC_SUPERIO on parisc architecture
Message-ID: <20130530162446.GA5750@ls3530.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If enabled, CONFIG_PARPORT_PC_SUPERIO scans on PC-like hardware for
various super-io chips by accessing i/o ports in a range which will
crash any parisc hardware at once.

In addition, parisc has it's own incompatible superio chip
(CONFIG_SUPERIO), so if we disable PARPORT_PC_SUPERIO completely for
parisc we can avoid that people by accident enable the parport_pc
superio option too.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 24e12d4..a505760 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -71,7 +71,7 @@ config PARPORT_PC_FIFO
 
 config PARPORT_PC_SUPERIO
 	bool "SuperIO chipset support"
-	depends on PARPORT_PC
+	depends on PARPORT_PC && !PARISC
 	help
 	  Saying Y here enables some probes for Super-IO chipsets in order to
 	  find out things like base addresses, IRQ lines and DMA channels.  It
