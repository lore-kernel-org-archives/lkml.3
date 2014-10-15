Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaJORGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:06:48 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33139 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJORGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:06:46 -0400
Subject: [PATCH v1 09/10] memory-hotplug: Remove "weak" from
 memory_block_size_bytes() declaration
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:06:44 -0600
Message-ID: <20141015170644.4063.6843.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: Rashika Kheria <rashika.kheria@gmail.com>
CC: Nathan Fontenot <nfont@austin.ibm.com>
CC: Anton Blanchard <anton@au1.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memory.h |    2 +-
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

