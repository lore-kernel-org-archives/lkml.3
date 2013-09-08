Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab3IHDTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56172 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756464Ab3IHDSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "David Howells" <dhowells@redhat.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.716528088@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [111/121] pci: frv architecture needs generic setup-bus
 infrastructure
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit cd0a2bfb77a3edeecd652081e0b1a163d3b0696b upstream.

Otherwise we get this link failure for frv's defconfig:

   LD      .tmp_vmlinux1
 drivers/built-in.o: In function `pci_assign_resource':
 (.text+0xbf0c): undefined reference to `pci_cardbus_resource_alignment'
 drivers/built-in.o: In function `pci_setup':
 pci.c:(.init.text+0x174): undefined reference to `pci_realloc_get_opt'
 pci.c:(.init.text+0x1a0): undefined reference to `pci_realloc_get_opt'
 make[1]: *** [.tmp_vmlinux1] Error 1

Cc: David Howells <dhowells@redhat.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 083a49f..165274c 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_UNICORE32) += setup-bus.o setup-irq.o
 obj-$(CONFIG_PARISC) += setup-bus.o
 obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
 obj-$(CONFIG_PPC) += setup-bus.o
+obj-$(CONFIG_FRV) += setup-bus.o
 obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
 obj-$(CONFIG_X86_VISWS) += setup-irq.o
 obj-$(CONFIG_MN10300) += setup-bus.o

