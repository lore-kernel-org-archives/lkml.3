Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3E1TVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:21:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3E1TV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:21:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/4] MN10300: Need pci_iomap() and __pci_ioport_map()
 defining [ver #2]
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Ken Cox <jkc@redhat.com>
Date: Tue, 28 May 2013 20:21:25 +0100
Message-ID: <20130528192125.20162.94350.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130528192102.20162.96295.stgit@warthog.procyon.org.uk>
References: <20130528192102.20162.96295.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the generic definitions of pci_iomap() and __pci_ioport_map()
otherwise we can get errors like:

lib/pci_iomap.c: In function 'pci_iomap':
lib/pci_iomap.c:37: error: implicit declaration of function '__pci_ioport_map'
lib/pci_iomap.c:37: warning: return makes pointer from integer without a cast

and:

drivers/pci/quirks.c: In function 'disable_igfx_irq':
drivers/pci/quirks.c:2893: error: implicit declaration of function 'pci_iomap'
drivers/pci/quirks.c:2893: warning: initialization makes pointer from integer without a cast
drivers/pci/quirks.c: In function 'reset_ivb_igd':
drivers/pci/quirks.c:3133: warning: assignment makes pointer from integer without a cast

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Ken Cox <jkc@redhat.com>
---

 arch/mn10300/include/asm/pci.h |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/arch/mn10300/include/asm/pci.h b/arch/mn10300/include/asm/pci.h
index 8137c25..6f31cc0 100644
--- a/arch/mn10300/include/asm/pci.h
+++ b/arch/mn10300/include/asm/pci.h
@@ -103,4 +103,6 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 	return channel ? 15 : 14;
 }
 
+#include <asm-generic/pci_iomap.h>
+
 #endif /* _ASM_PCI_H */

