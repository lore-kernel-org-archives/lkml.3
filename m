Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab3CSCbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:31:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46274 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab3CSCbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:31:18 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 14/21] kexec, elf: introduce NT_VMCORE_DEBUGINFO note type
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:02:05 +0900
Message-ID: <20130316040205.15064.31351.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces NT_VMCORE_DEBUGINFO to a unique note type in
VMCOREINFO name, which has had no name so far. The name means that
it's a kind of note type in vmcoreinfo that contains system kernel's
debug information.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 include/uapi/linux/elf.h |    4 ++++
 kernel/kexec.c           |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 8072d35..b869904 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -398,6 +398,10 @@ typedef struct elf64_shdr {
 #define NT_METAG_CBUF	0x500		/* Metag catch buffer registers */
 #define NT_METAG_RPIPE	0x501		/* Metag read pipeline state */
 
+/*
+ * Notes exported from /proc/vmcore, belonging to "VMCOREINFO" name.
+ */
+#define NT_VMCORE_DEBUGINFO	0	/* vmcore system kernel's debuginfo */
 
 /* Note header in a PT_NOTE section */
 typedef struct elf32_note {
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 195de6d..6597b82 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1438,8 +1438,8 @@ static void update_vmcoreinfo_note(void)
 
 	if (!vmcoreinfo_size)
 		return;
-	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
-			      vmcoreinfo_size);
+	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, NT_VMCORE_DEBUGINFO,
+			      vmcoreinfo_data, vmcoreinfo_size);
 	final_note(buf);
 }
 

