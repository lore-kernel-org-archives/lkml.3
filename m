Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaKSU4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:56:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbaKSUyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Nathan Fontenot <nfont@austin.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3.17 114/141] memory-hotplug: Remove "weak" from memory_block_size_bytes() declaration
Date: Wed, 19 Nov 2014 12:52:17 -0800
Message-Id: <20141119205154.395261568@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -35,7 +35,7 @@ struct memory_block {
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
-unsigned long __weak memory_block_size_bytes(void);
+unsigned long memory_block_size_bytes(void);
 
 /* These states are exposed to userspace as text strings in sysfs */
 #define	MEM_ONLINE		(1<<0) /* exposed to userspace */


