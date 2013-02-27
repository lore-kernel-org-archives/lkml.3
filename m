Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab3B0Tls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:41:48 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59873 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3B0Tlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:41:47 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Wed, 27 Feb 2013 13:41:46 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Andy King <acking@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dtor@vmware.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] misc/vmw_vmci: Add dependency on CONFIG_NET
Date: Wed, 27 Feb 2013 11:41:41 -0800
Message-Id: <1361994101-15781-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the vmw_vmci driver with CONFIG_NET undefined results in:

drivers/built-in.o: In function `__qp_memcpy_from_queue.isra.13':
vmci_queue_pair.c:(.text+0x1671a8): undefined reference to `memcpy_toiovec'
drivers/built-in.o: In function `__qp_memcpy_to_queue.isra.14':
vmci_queue_pair.c:(.text+0x167341): undefined reference to `memcpy_fromiovec'
make[1]: [vmlinux] Error 1 (ignored)

since memcpy_toiovec and memcpy_fromiovec are defined in the networking code.
Add the missing dependency.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/misc/vmw_vmci/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/Kconfig b/drivers/misc/vmw_vmci/Kconfig
index 39c2eca..ea98f7e 100644
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
-- 
1.7.9.7

