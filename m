Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaCFEGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:06:13 -0500
Received: from snt0-omc1-s36.snt0.hotmail.com ([65.55.90.47]:8082 "EHLO
	snt0-omc1-s36.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbaCFEGL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:06:11 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 23:06:11 EST
X-TMN: [q3X7EOTUuYLiEY4N5VVdv4W+DggskIxk]
X-Originating-Email: [nickkrause@sympatico.ca]
Message-ID: <SNT145-W1141791FC5F60B7E0788170A5880@phx.gbl>
From: Nick Krause <nickkrause@sympatico.ca>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Patch[Kernel 3.13.5]
Date: Thu, 6 Mar 2014 04:00:04 +0000
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Mar 2014 04:00:05.0020 (UTC) FILETIME=[8E725DC0:01CF38F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my first patch, adding a break point to fix bug 60845, case fallout through on switch 
in arch/mips/pci/msi-octeon.c.

--- //home/nick/linux-3.13.5/arch/mips/pci/msi-octeon.c.orig    2014-03-05 22:48:19.084372515 -0500
+++ //home/nick/linux-3.13.5/arch/mips/pci/msi-octeon.c    2014-03-05 22:48:48.388372344 -0500
@@ -150,6 +150,7 @@ msi_irq_allocated:
         msg.address_lo =
             ((128ul << 20) + CVMX_PCI_MSI_RCV) & 0xffffffff;
         msg.address_hi = ((128ul << 20) + CVMX_PCI_MSI_RCV)>> 32;
+        break;
     case OCTEON_DMA_BAR_TYPE_BIG:
         /* When using big bar, Bar 0 is based at 0 */
         msg.address_lo = (0 + CVMX_PCI_MSI_RCV) & 0xffffffff;
Got one error no maintainer otherwise not issues with coding style.
Nick 
 		 	   		  