Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab3CSCbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:31:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46284 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab3CSCb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:31:28 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 15/21] elf: introduce NT_VMCORE_PAD type
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:02:11 +0900
Message-ID: <20130316040211.15064.1645.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
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

