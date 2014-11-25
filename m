Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaKYKoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:44:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaKYKn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Nathan Fontenot <nfont@austin.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 244/254] memory-hotplug: Remove "weak" from memory_block_size_bytes() declaration
Date: Tue, 25 Nov 2014 10:39:54 +0000
Message-Id: <1416912004-5928-245-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit e0a8400c6923a163265d52798cdd4c33f3f8ab5a upstream.

drivers/base/memory.c provides a default memory_block_size_bytes()
definition explicitly marked "weak".  Several architectures provide their
own definitions intended to override the default, but the "weak" attribute
on the declaration applied to the arch definitions as well, so the linker
chose one based on link order (see 10629d711ed7 ("PCI: Remove __weak
annotation from pcibios_get_phb_of_node decl")).

Remove the "weak" attribute from the declaration so we always prefer a
non-weak definition over the weak one, independent of link order.

Fixes: 41f107266b19 ("drivers: base: Add prototype declaration to the header file")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
CC: Rashika Kheria <rashika.kheria@gmail.com>
CC: Nathan Fontenot <nfont@austin.ibm.com>
CC: Anton Blanchard <anton@au1.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/memory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memory.h b/include/linux/memory.h
index bb7384e3c3d8..8b8d8d12348e 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -35,7 +35,7 @@ struct memory_block {
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
-unsigned long __weak memory_block_size_bytes(void);
+unsigned long memory_block_size_bytes(void);
 
 /* These states are exposed to userspace as text strings in sysfs */
 #define	MEM_ONLINE		(1<<0) /* exposed to userspace */
-- 
2.1.0

