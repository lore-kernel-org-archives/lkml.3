Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101Ab3DJWxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:53:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937629Ab3DJWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jay Estabrook <jay.estabrook@gmail.com>,
        Matt Turner <mattst88@gmail.com>, Michael Cree <mcree@orcon.net.nz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 09/19] alpha: Add irongate_io to PCI bus resources
Date: Wed, 10 Apr 2013 15:50:32 -0700
Message-Id: <20130410225027.772336313@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410225026.833809117@linuxfoundation.org>
References: <20130410225026.833809117@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 arch/alpha/kernel/sys_nautilus.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -189,6 +189,10 @@ nautilus_machine_check(unsigned long vec
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


