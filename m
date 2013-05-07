Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab3EGEKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:10:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab3EGD6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:48 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=yh3clm0PiIsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3q1v8UrOuK4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=F1RueMgOAAAA:8 a=Z4Rwk6OoAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=MSl-tDqOz04A:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035843.434153700@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jay Estabrook <jay.estabrook@gmail.com>, Matt Turner <mattst88@gmail.com>,
        Michael Cree <mcree@orcon.net.nz>
Subject: [015/126] alpha: Add irongate_io to PCI bus resources
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0015-alpha-Add-irongate_io-to-PCI-bus-resources.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jay Estabrook <jay.estabrook@gmail.com>

[ Upstream commit aa8b4be3ac049c8b1df2a87e4d1d902ccfc1f7a9 ]

Fixes a NULL pointer dereference at boot on UP1500.

Cc: stable@vger.kernel.org
Reviewed-and-Tested-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Jay Estabrook <jay.estabrook@gmail.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/alpha/kernel/sys_nautilus.c |    5 +++++
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
1.7.10.4


