Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaINIoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:44:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47212 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaINIoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:44:37 -0400
Message-ID: <54155579.6040808@gmail.com>
Date: Sun, 14 Sep 2014 16:44:41 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>, grant.likely@linaro.org, tony@atomide.com,
        bhelgaas@google.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        rob.herring@calxeda.com, sebott@linux.vnet.ibm.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/microblaze/pci/pci-common.c: Export 'isa_io_base' for
 compiling break
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export it just like another architectures have done (e.g. powerpc). The
related error with allmodconfig:

  ERROR: "isa_io_base" [sound/pci/vx222/snd-vx222.ko] undefined!
  ERROR: "isa_io_base" [sound/pci/trident/snd-trident.ko] undefined!
  ...
  ERROR: "isa_io_base" [drivers/ata/pata_artop.ko] undefined!
  ERROR: "isa_io_base" [drivers/ata/libata.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/microblaze/pci/pci-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 9037914..6c57a6a 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -48,6 +48,7 @@ static int global_phb_number;		/* Global phb counter */
 resource_size_t isa_mem_base;
 
 unsigned long isa_io_base;
+EXPORT_SYMBOL(isa_io_base);
 static int pci_bus_count;
 
 struct pci_controller *pcibios_alloc_controller(struct device_node *dev)
-- 
1.9.3
