Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3AXWtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:49:47 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59844 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3AXWte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:49:34 -0500
Date: Thu, 24 Jan 2013 14:49:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: George Zhang <georgezhang@vmware.com>, Andy king <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org
Subject: [patch] drivers, vmci: Fix build error
Message-ID: <alpine.DEB.2.00.1301241447420.30690@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't rely on vmalloc.h being included by other included files because
under some configs it is possible for the build to fail:

drivers/misc/vmw_vmci/vmci_queue_pair.c: In function 'qp_free_queue':
drivers/misc/vmw_vmci/vmci_queue_pair.c:270: error: implicit declaration of function 'vunmap'
drivers/misc/vmw_vmci/vmci_queue_pair.c:277: error: implicit declaration of function 'vfree'
drivers/misc/vmw_vmci/vmci_queue_pair.c: In function 'qp_alloc_queue':
drivers/misc/vmw_vmci/vmci_queue_pair.c:302: error: implicit declaration of function 'vmalloc'
drivers/misc/vmw_vmci/vmci_queue_pair.c:302: warning: assignment makes pointer from integer without a cast
drivers/misc/vmw_vmci/vmci_queue_pair.c:324: error: implicit declaration of function 'vmap'
drivers/misc/vmw_vmci/vmci_queue_pair.c:324: error: 'VM_MAP' undeclared (first use in this function)
drivers/misc/vmw_vmci/vmci_queue_pair.c:324: error: (Each undeclared identifier is reported only once
drivers/misc/vmw_vmci/vmci_queue_pair.c:324: error: for each function it appears in.)
drivers/misc/vmw_vmci/vmci_queue_pair.c: In function 'qp_host_map_queues':
drivers/misc/vmw_vmci/vmci_queue_pair.c:843: error: 'VM_MAP' undeclared (first use in this function)

Fix the build by directly including vmalloc.h.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/socket.h>
 #include <linux/wait.h>
+#include <linux/vmalloc.h>
 
 #include "vmci_handle_array.h"
 #include "vmci_queue_pair.h"
