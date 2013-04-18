Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3DRJRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:17:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40037 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3DRJRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jay Estabrook <jay.estabrook@gmail.com>, Matt Turner <mattst88@gmail.com>,
        Michael Cree <mcree@orcon.net.nz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 12/72] alpha: Add irongate_io to PCI bus resources
Date: Thu, 18 Apr 2013 10:15:57 +0100
Message-Id: <1366276617-3553-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Estabrook <jay.estabrook@gmail.com>

commit aa8b4be3ac049c8b1df2a87e4d1d902ccfc1f7a9 upstream.

Fixes a NULL pointer dereference at boot on UP1500.

Reviewed-and-Tested-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Jay Estabrook <jay.estabrook@gmail.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/alpha/kernel/sys_nautilus.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/alpha/kernel/sys_nautilus.c b/arch/alpha/kernel/sys_nautilus.c
index 4d4c046..1383f86 100644
--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -188,6 +188,10 @@ nautilus_machine_check(unsigned long vector, unsigned long la_ptr)
 extern void free_reserved_mem(void *, void *);
 extern void pcibios_claim_one_bus(struct pci_bus *);
 
+static struct resource irongate_io = {
+	.name	= "Irongate PCI IO",
+	.flags	= IORESOURCE_IO,
+};
 static struct resource irongate_mem = {
 	.name	= "Irongate PCI MEM",
 	.flags	= IORESOURCE_MEM,
@@ -209,6 +213,7 @@ nautilus_init_pci(void)
 
 	irongate = pci_get_bus_and_slot(0, 0);
 	bus->self = irongate;
+	bus->resource[0] = &irongate_io;
 	bus->resource[1] = &irongate_mem;
 
 	pci_bus_size_bridges(bus);
-- 
1.8.1.2

