Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3JDKbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:31:42 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50326 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3JDKbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:31:39 -0400
Subject: [PATCH 06/19] Define API for reading arch specif Program Headers
 for Core
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@in.ibm.com>
Cc: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Fri, 04 Oct 2013 16:01:30 +0530
Message-ID: <20131004103130.1612.72634.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-4790-0000-0000-00000AA49A4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

The binfmt ELF defines APIs for the "arch" specific Program headers to be
written to the ELF core. Define the "read" (or copy) variants of the APIs, to
collect it for the application core dump(which is a read based approach).

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 include/linux/elfcore.h |    3 +++
 kernel/elfcore.c        |    6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index cdd3d13..cf13b45 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -66,6 +66,9 @@ extern int
 elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 			   unsigned long limit);
 extern int
+elf_core_copy_extra_phdrs(char *buf, loff_t offset, size_t *size,
+				unsigned long limit);
+extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
 extern size_t elf_core_extra_data_size(void);
 
diff --git a/kernel/elfcore.c b/kernel/elfcore.c
index ff915ef..f422c6c 100644
--- a/kernel/elfcore.c
+++ b/kernel/elfcore.c
@@ -16,6 +16,12 @@ int __weak elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *
 	return 1;
 }
 
+int __weak elf_core_copy_extra_phdrs(char *buf, loff_t offset, size_t *size,
+					unsigned long limit)
+{
+	return 1;
+}
+
 int __weak elf_core_write_extra_data(struct file *file, size_t *size,
 				     unsigned long limit)
 {

