Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3BUVrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:47:07 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39581 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3BUVrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:47:05 -0500
Date: Thu, 21 Feb 2013 13:47:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: George Zhang <georgezhang@vmware.com>, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org
Subject: [patch] drivers, vmci: vmware vmci driver depends on CONFIG_NET
Message-ID: <alpine.DEB.2.02.1302211344180.28115@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_VMWARE_VMCI requires CONFIG_NET, otherwise there is a link error:

drivers/built-in.o: In function `__qp_memcpy_from_queue.isra.11':
vmci_queue_pair.c:(.text+0x2d4509): undefined reference to `memcpy_toiovec'
drivers/built-in.o: In function `__qp_memcpy_to_queue.isra.12':
vmci_queue_pair.c:(.text+0x2d4709): undefined reference to `memcpy_fromiovec'

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/misc/vmw_vmci/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/Kconfig b/drivers/misc/vmw_vmci/Kconfig
--- a/drivers/misc/vmw_vmci/Kconfig
+++ b/drivers/misc/vmw_vmci/Kconfig
@@ -4,7 +4,7 @@
 
 config VMWARE_VMCI
 	tristate "VMware VMCI Driver"
-	depends on X86 && PCI
+	depends on X86 && PCI && NET
 	help
 	  This is VMware's Virtual Machine Communication Interface.  It enables
 	  high-speed communication between host and guest in a virtual
