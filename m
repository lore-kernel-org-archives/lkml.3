Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab3CSCaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:30:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47001 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab3CSCaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:30:11 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 02/21] vmcore: clean up by removing unnecessary variable
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:00:58 +0900
Message-ID: <20130316040058.15064.35158.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable j has int type but it's compared with u64 type.

Also, the purpose of the variable j is exactly what the variable
real_sz is used for now. Replace the variable j by the variable
real_sz and remove the variable j.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 163281e..94743d2 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -261,7 +261,6 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
-		int j;
 		void *notes_section;
 		struct vmcore *new;
 		u64 offset, max_sz, sz, real_sz = 0;
@@ -279,7 +278,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 			return rc;
 		}
 		nhdr_ptr = notes_section;
-		for (j = 0; j < max_sz; j += sz) {
+		while (real_sz < max_sz) {
 			if (nhdr_ptr->n_namesz == 0)
 				break;
 			sz = sizeof(Elf64_Nhdr) +
@@ -342,7 +341,6 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff);
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
-		int j;
 		void *notes_section;
 		struct vmcore *new;
 		u64 offset, max_sz, sz, real_sz = 0;
@@ -360,7 +358,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 			return rc;
 		}
 		nhdr_ptr = notes_section;
-		for (j = 0; j < max_sz; j += sz) {
+		while (real_sz < max_sz) {
 			if (nhdr_ptr->n_namesz == 0)
 				break;
 			sz = sizeof(Elf32_Nhdr) +

