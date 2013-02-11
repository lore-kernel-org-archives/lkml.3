Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab3BKXAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:00:46 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:41934 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab3BKXAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:00:44 -0500
Message-ID: <1360623637.2950.63.camel@lorien2>
Subject: [PATCH 1/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to return
 bus number and device id
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: bhelgaas@google.com, Joerg Roedel <joro@8bytes.org>
Cc: paulmck@linux.vnet.ibm.com, linasvepstas@gmail.com, dhowells@redhat.com,
        davej@redhat.com, tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, shemminger@vyatta.com, jiang.liu@huawei.com,
        wangyijing@huawei.com, shuahkhan@gmail.com
Date: Mon, 11 Feb 2013 16:00:37 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci defines PCI_DEVFN(), PCI_SLOT(), and PCI_FUNC() interfaces, however,
it doesn't have interfaces to return PCI bus and PCI device id. Drivers
(AMD IOMMU, and AER) implement module specific definitions for PCI_BUS()
and AMD_IOMMU driver also has a module specific interface to calculate PCI   
device id from bus number and devfn.

Add PCI_BUS and PCI_DEVID interfaces to return PCI bus number and PCI device
id respectively to avoid the need for duplicate definitions in other modules.
AER driver code and AMD IOMMU driver define PCI_BUS. AMD IOMMU driver defines
an interface to calculate device id from bus number, and devfn pair.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 include/uapi/linux/pci.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/pci.h b/include/uapi/linux/pci.h
index 3c292bc0..6b2c8b3 100644
--- a/include/uapi/linux/pci.h
+++ b/include/uapi/linux/pci.h
@@ -30,6 +30,10 @@
 #define PCI_DEVFN(slot, func)	((((slot) & 0x1f) << 3) | ((func) & 0x07))
 #define PCI_SLOT(devfn)		(((devfn) >> 3) & 0x1f)
 #define PCI_FUNC(devfn)		((devfn) & 0x07)
+#define PCI_DEVID(bus, devfn)	((((u16)bus) << 8) | devfn)
+
+/* return bus from PCI devid = ((u16)bus_number) << 8) | devfn */
+#define PCI_BUS(x) (((x) >> 8) & 0xff)
 
 /* Ioctls for /proc/bus/pci/X/Y nodes. */
 #define PCIIOC_BASE		('P' << 24 | 'C' << 16 | 'I' << 8)
-- 
1.7.9.5



