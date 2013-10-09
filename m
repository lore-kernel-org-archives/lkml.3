Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3JIAPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:15:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60577 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab3JIAPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:15:39 -0400
Date: Wed, 09 Oct 2013 01:15:37 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 09/13] binfmt_elf: count notes towards coredump limit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThRB-0002ym-O8@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/binfmt_elf.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bb59220..42ef312 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2034,7 +2034,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 	int has_dumped = 0;
 	mm_segment_t fs;
 	int segs;
-	size_t size = 0;
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff;
@@ -2155,7 +2154,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 	if (!elf_core_write_extra_phdrs(cprm, offset))
 		goto end_coredump;
 
-	size = cprm->written;
  	/* write out the notes section */
 	if (!write_note_info(&info, cprm))
 		goto end_coredump;
@@ -2167,7 +2165,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 	if (!dump_seek(cprm->file, dataoff - cprm->written))
 		goto end_coredump;
 
-	cprm->written = size;
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
-- 
1.7.2.5


