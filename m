Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaCVVxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 17:53:14 -0400
Received: from snt0-omc3-s42.snt0.hotmail.com ([65.54.51.79]:20951 "EHLO
	snt0-omc3-s42.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbaCVVxM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 17:53:12 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Mar 2014 17:53:12 EDT
X-TMN: [XXg/WSBJU+CNLw4mULoiK/xH9VLgw5fY]
X-Originating-Email: [nickkrause@sympatico.ca]
Message-ID: <SNT145-W982FA6E38A0213DE61456DA5780@phx.gbl>
From: Nick Krause <nickkrause@sympatico.ca>
To: "ralf@linux-mips.org" <ralf@linux-mips.org>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: PATCH[60485 Bug adding breakpoint]
Date: Sat, 22 Mar 2014 21:47:06 +0000
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Mar 2014 21:47:06.0269 (UTC) FILETIME=[44B1B4D0:01CF4618]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my new patch as corrected for the the bug 60845.
https://bugzilla.kernel.org/show_bug.cgi?id=60845
This is the link to the bug and my comments / conversation on to get the corrections needed.
Below is my patch for the bug, please let me know if it gets added finally .

--- linux-3.13.6/arch/mips/pci/msi-octeon.c.orig    2014-03-22 17:32:44.762754254 -0400
+++ linux-3.13.6/arch/mips/pci/msi-octeon.c    2014-03-22 17:34:19.974753699 -0400
@@ -150,6 +150,7 @@ msi_irq_allocated:
         msg.address_lo =
             ((128ul << 20) + CVMX_PCI_MSI_RCV) & 0xffffffff;
         msg.address_hi = ((128ul << 20) + CVMX_PCI_MSI_RCV)>> 32;
+        break;
     case OCTEON_DMA_BAR_TYPE_BIG:
         /* When using big bar, Bar 0 is based at 0 */
         msg.address_lo = (0 + CVMX_PCI_MSI_RCV) & 0xffffffff;
Signed-off-by: nickkrause@sympatico.ca
Nick
 		 	   		  