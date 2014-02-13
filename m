Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaBMQBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:01:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:39020 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaBMQBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:01:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <sparclinux@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] sparc: fix implicit include of slab.h in leon_pci_grpci2.c
Date: Thu, 13 Feb 2014 10:59:18 -0500
Message-ID: <1392307158-6932-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix:

arch/sparc/kernel/leon_pci_grpci2.c: In function 'grpci2_of_probe':
arch/sparc/kernel/leon_pci_grpci2.c:720:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
arch/sparc/kernel/leon_pci_grpci2.c:720:20: error: assignment makes pointer from integer without a cast [-Werror]
arch/sparc/kernel/leon_pci_grpci2.c:882:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
cc1: all warnings being treated as errors
make[2]: *** [arch/sparc/kernel/leon_pci_grpci2.o] Error 1

According to Stephen, these types of failures are caused by
commit 2bd59d48ebfb ("cgroup: convert to kernfs") which was
being included implicitly via cgroup.h's inclusion of xattr.h
(which has now been removed).

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/sparc/kernel/leon_pci_grpci2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/kernel/leon_pci_grpci2.c b/arch/sparc/kernel/leon_pci_grpci2.c
index 5f0402aab7fb..24d6a4446349 100644
--- a/arch/sparc/kernel/leon_pci_grpci2.c
+++ b/arch/sparc/kernel/leon_pci_grpci2.c
@@ -8,6 +8,7 @@
 #include <linux/of_device.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <asm/io.h>
-- 
1.8.5.2

