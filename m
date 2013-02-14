Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995Ab3BNKMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:12:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43570 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab3BNKMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:13 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 05/13] vmcore: modify ELF32 code according to new type
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:12:10 +0900
Message-ID: <20130214101210.22466.36330.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On elf32 mmap() is not supported. All vmcore objects are in old
memory.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 43d338a..7e3f922 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -389,6 +389,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 			kfree(notes_section);
 			return -ENOMEM;
 		}
+		new->type = VMCORE_OLD_MEMORY;
 		new->paddr = phdr_ptr->p_offset;
 		new->size = real_sz;
 		list_add_tail(&new->list, vc_list);
@@ -486,6 +487,7 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 		new = get_new_element();
 		if (!new)
 			return -ENOMEM;
+		new->type = VMCORE_OLD_MEMORY;
 		new->paddr = phdr_ptr->p_offset;
 		new->size = phdr_ptr->p_memsz;
 		list_add_tail(&new->list, vc_list);

