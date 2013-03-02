Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3CEHGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:06:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50259 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3CEHGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:06:16 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v2 14/20] elf: introduce NT_VMCORE_PAD type
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 17:37:09 +0900
Message-ID: <20130302083709.31252.77794.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NT_VMCORE_PAD type is introduced to make both crash_notes buffer
and vmcoreinfo_note buffer satisfy mmap()'s page-size boundary
requirement by filling them with this note type.

The purpose of this type is just to align the buffer in page-size
boundary; it has no meaning in contents, which are fully filled with
zero.

This note type belongs to "VMCOREINFO" name space and the type in this
name space is 7. The reason why the numbers from 1 to 5 is not chosen
is that for the ones from 1 to 4, there are the corresponding note
types using the same number in "CORE" name space, and crash utility
and makedumpfile don't distinguish note types by name space at all;
for the remaining 5, this has somehow not been used since v2.4.0
kernel despite the fact that NT_AUXV is defined as 6. It looks that it
avoids some dependency to 5. Here simply 5 is not chosen for
conservative viewpoint.

By this change, gdb and binutils work well without any change, but
makedumpfile and crash utility need their changes to distinguish two
note types in "VMCOREINFO" name space.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 include/uapi/linux/elf.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index b869904..9753e4c 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -402,6 +402,7 @@ typedef struct elf64_shdr {
  * Notes exported from /proc/vmcore, belonging to "VMCOREINFO" name.
  */
 #define NT_VMCORE_DEBUGINFO	0	/* vmcore system kernel's debuginfo */
+#define NT_VMCORE_PAD		7	/* vmcore padding of note segments */
 
 /* Note header in a PT_NOTE section */
 typedef struct elf32_note {

