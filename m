Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaHNKPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:15:31 -0400
Received: from [119.145.14.64] ([119.145.14.64]:60038 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaHNKP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:15:29 -0400
From: HuKeping <hukeping@huawei.com>
To: <vgoyal@redhat.com>, <hbabu@us.ibm.com>, <rob@landley.net>
CC: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peifeiyue@huawei.com>
Subject: [PATCH v3] Add arm description to Documentation/kdump/kdump.txt
Date: Thu, 14 Aug 2014 17:55:32 +0800
Message-ID: <1408010132-62794-1-git-send-email-hukeping@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----------------------------------------

Add arm specific parts to kdump kernel documentation.

v2 -> v3
- fix some spelling mistakes

Signed-off-by: Hu Keping <hukeping@huawei.com>
---
 Documentation/kdump/kdump.txt | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 9c7fd988..8c632db 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -18,7 +18,7 @@ memory image to a dump file on the local disk, or across the network to
 a remote system.
 
 Kdump and kexec are currently supported on the x86, x86_64, ppc64, ia64,
-and s390x architectures.
+s390x and arm architectures.
 
 When the system kernel boots, it reserves a small section of memory for
 the dump-capture kernel. This ensures that ongoing Direct Memory Access
@@ -119,7 +119,7 @@ There are two possible methods of using Kdump.
 2) Or use the system kernel binary itself as dump-capture kernel and there is
    no need to build a separate dump-capture kernel. This is possible
    only with the architectures which support a relocatable kernel. As
-   of today, i386, x86_64, ppc64 and ia64 architectures support relocatable
+   of today, i386, x86_64, ppc64, ia64 and arm architectures support relocatable
    kernel.
 
 Building a relocatable kernel is advantageous from the point of view that
@@ -248,6 +248,13 @@ Dump-capture kernel config options (Arch Dependent, ia64)
   kernel will be aligned to 64Mb, so if the start address is not then
   any space below the alignment point will be wasted.
 
+Dump-capture kernel config options (Arch Dependent, arm)
+----------------------------------------------------------
+
+-   To use a relocatable kernel,
+    Enable "AUTO_ZRELADDR" support under "Boot" options:
+
+    AUTO_ZRELADDR=y
 
 Extended crashkernel syntax
 ===========================
@@ -263,6 +270,10 @@ The syntax is:
     crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
     range=start-[end]
 
+Please note, on arm, the offset is required.
+    crashkernel=<range1>:<size1>[,<range2>:<size2>,...]@offset
+    range=start-[end]
+
     'start' is inclusive and 'end' is exclusive.
 
 For example:
@@ -303,6 +314,12 @@ Boot into System Kernel
    on the memory consumption of the kdump system. In general this is not
    dependent on the memory size of the production system.
 
+   On arm, use "crashkernel=Y@X". Note that the start address of the kernel
+   will be aligned to 128MiB (0x08000000), so if the start address is not then
+   any space below the alignment point may be overwritten by the dump-capture kernel,
+   which means it is possible that the vmcore is not that precise as expected.
+
+
 Load the Dump-capture Kernel
 ============================
 
@@ -322,7 +339,8 @@ For ia64:
 	- Use vmlinux or vmlinuz.gz
 For s390x:
 	- Use image or bzImage
-
+For arm:
+	- Use zImage
 
 If you are using a uncompressed vmlinux image then use following command
 to load dump-capture kernel.
@@ -338,6 +356,15 @@ to load dump-capture kernel.
    --initrd=<initrd-for-dump-capture-kernel> \
    --append="root=<root-dev> <arch-specific-options>"
 
+If you are using a compressed zImage, then use following command
+to load dump-capture kernel.
+
+   kexec --type zImage -p <dump-capture-kernel-bzImage> \
+   --initrd=<initrd-for-dump-capture-kernel> \
+   --dtb=<dtb-for-dump-capture-kernel> \
+   --append="root=<root-dev> <arch-specific-options>"
+
+
 Please note, that --args-linux does not need to be specified for ia64.
 It is planned to make this a no-op on that architecture, but for now
 it should be omitted
@@ -354,6 +381,9 @@ For ppc64:
 For s390x:
 	"1 maxcpus=1 cgroup_disable=memory"
 
+For arm:
+	"1 maxcpus=1 reset_devices"
+
 Notes on loading the dump-capture kernel:
 
 * By default, the ELF headers are stored in ELF64 format to support
-- 
1.8.5.5

