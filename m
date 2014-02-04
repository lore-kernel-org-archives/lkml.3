Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935470AbaBDVxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:53:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934347AbaBDVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 3.13 004/140] xen/pci: Fix build on non-x86
Date: Tue,  4 Feb 2014 13:09:51 -0800
Message-Id: <20140204211037.096077243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit b7ef4a6dd35d1b47db72fbd1a31c8fd0da7a74f3 upstream.

We can't include <asm/pci_x86.h> if this isn't x86, and we only need
it if CONFIG_PCI_MMCONFIG is enabled.

Fixes: 8deb3eb1461e ('xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas.')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -26,7 +26,9 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include "../pci/pci.h"
+#ifdef CONFIG_PCI_MMCONFIG
 #include <asm/pci_x86.h>
+#endif
 
 static bool __read_mostly pci_seg_supported = true;
 


