Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071Ab3DDNrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:47:05 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:64336 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761032Ab3DDNrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:47:03 -0400
Message-ID: <1365083221.1830.51.camel@x61.thuisdomein>
Subject: [PATCH v2] MIPS: Alchemy: Fix typo "CONFIG_DEBUG_PCI"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Apr 2013 15:47:01 +0200
In-Reply-To: <515D69B6.6040302@cogentembedded.com>
References: <1365074738.1830.38.camel@x61.thuisdomein>
	 <515D69B6.6040302@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2013 13:47:01.0691 (UTC) FILETIME=[E26BE8B0:01CE313A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7517de348663b08a808aff44b5300e817157a568 ("MIPS: Alchemy: Redo
PCI as platform driver") added a reference to CONFIG_DEBUG_PCI. Change
it to CONFIG_PCI_DEBUG, as that is a valid Kconfig macro.

Also add a newline to a debugging printk that this fix enables.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This version has a verbose commit explanation, as Sergei requested.
Still entirely untested.

 arch/mips/pci/pci-alchemy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pci/pci-alchemy.c b/arch/mips/pci/pci-alchemy.c
index 38a80c8..d1faece 100644
--- a/arch/mips/pci/pci-alchemy.c
+++ b/arch/mips/pci/pci-alchemy.c
@@ -19,7 +19,7 @@
 #include <asm/mach-au1x00/au1000.h>
 #include <asm/tlbmisc.h>
 
-#ifdef CONFIG_DEBUG_PCI
+#ifdef CONFIG_PCI_DEBUG
 #define DBG(x...) printk(KERN_DEBUG x)
 #else
 #define DBG(x...) do {} while (0)
@@ -162,7 +162,7 @@ static int config_access(unsigned char access_type, struct pci_bus *bus,
 	if (status & (1 << 29)) {
 		*data = 0xffffffff;
 		error = -1;
-		DBG("alchemy-pci: master abort on cfg access %d bus %d dev %d",
+		DBG("alchemy-pci: master abort on cfg access %d bus %d dev %d\n",
 		    access_type, bus->number, device);
 	} else if ((status >> 28) & 0xf) {
 		DBG("alchemy-pci: PCI ERR detected: dev %d, status %lx\n",
-- 
1.7.11.7

