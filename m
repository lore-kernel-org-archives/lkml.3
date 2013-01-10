Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3AJXlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:41:49 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55380 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431Ab3AJXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:41:44 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: [PATCH 6/6] VMCI: include slab.h into files using kmalloc/kfree
Date: Thu, 10 Jan 2013 15:41:43 -0800
Message-Id: <1357861303-25903-6-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357861303-25903-1-git-send-email-dtor@vmware.com>
References: <1357861303-25903-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not rely on implicit header dependencies as they are known to
break.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Andy King <acking@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_guest.c |    3 +++
 drivers/misc/vmw_vmci/vmci_host.c  |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index d7df6cf..de1a90b 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -19,12 +19,15 @@
 #include <linux/interrupt.h>
 #include <linux/highmem.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/vmalloc.h>
 
 #include "vmci_datagram.h"
 #include "vmci_doorbell.h"
diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci_host.c
index 16e7f54..d4722b3 100644
--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-- 
1.7.4.1

