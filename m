Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3FDW7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:59:35 -0400
Received: from 1wt.eu ([62.212.114.60]:35707 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3FDWnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:20 -0400
Message-Id: <20130604172132.876891038@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jay Estabrook <jay.estabrook@gmail.com>, Matt Turner <mattst88@gmail.com>,
        Michael Cree <mcree@orcon.net.nz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 062/184] alpha: Add irongate_io to PCI bus resources
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Estabrook <jay.estabrook@gmail.com>

commit aa8b4be3ac049c8b1df2a87e4d1d902ccfc1f7a9 upstream.

Fixes a NULL pointer dereference at boot on UP1500.

Reviewed-and-Tested-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Jay Estabrook <jay.estabrook@gmail.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/alpha/kernel/sys_nautilus.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/alpha/kernel/sys_nautilus.c b/arch/alpha/kernel/sys_nautilus.c
index 99c0f46..dc616b3 100644
--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -189,6 +189,10 @@ nautilus_machine_check(unsigned long vector, unsigned long la_ptr)
 extern void free_reserved_mem(void *, void *);
 extern void pcibios_claim_one_bus(struct pci_bus *);
 
+static struct resource irongate_io = {
+	.name	= "Irongate PCI IO",
+	.flags	= IORESOURCE_IO,
+};
 static struct resource irongate_mem = {
 	.name	= "Irongate PCI MEM",
 	.flags	= IORESOURCE_MEM,
@@ -210,6 +214,7 @@ nautilus_init_pci(void)
 
 	irongate = pci_get_bus_and_slot(0, 0);
 	bus->self = irongate;
+	bus->resource[0] = &irongate_io;
 	bus->resource[1] = &irongate_mem;
 
 	pci_bus_size_bridges(bus);
-- 
1.7.12.2.21.g234cd45.dirty



