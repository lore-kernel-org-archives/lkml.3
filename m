Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3AJXlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:41:50 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:54399 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441Ab3AJXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:41:44 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: [PATCH 1/6] VMCI: Add PCI as a dependency
Date: Thu, 10 Jan 2013 15:41:38 -0800
Message-Id: <1357861303-25903-1-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>

Add PCI as a dependency to our build, since we always compile in the guest-side
PCI device support.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andy King <acking@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

Greg,

Here is the set of patches addressing compilation issues in VMCI
reported on LKML by Randy and also change renaming PPNSet to ppn_set
that I promised you.

Thanks,
Dmitry

 drivers/misc/vmw_vmci/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/vmw_vmci/Kconfig b/drivers/misc/vmw_vmci/Kconfig
index 55015e7..39c2eca 100644
--- a/drivers/misc/vmw_vmci/Kconfig
+++ b/drivers/misc/vmw_vmci/Kconfig
@@ -4,7 +4,7 @@
 
 config VMWARE_VMCI
 	tristate "VMware VMCI Driver"
-	depends on X86
+	depends on X86 && PCI
 	help
 	  This is VMware's Virtual Machine Communication Interface.  It enables
 	  high-speed communication between host and guest in a virtual
-- 
1.7.4.1

