Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaANTdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:33:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaANTdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:33:39 -0500
Date: Tue, 14 Jan 2014 14:33:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Kexec Mailing List <kexec@lists.infradead.org>, Greg KH <gregkh@suse.de>
Subject: [PATCH] kdump: Fix exported size of vmcoreinfo note
Message-ID: <20140114193311.GL3096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we seem to be exporting the max data size contained inside
vmcoreinfo note. But this does not include the size of meta data around
vmcore info data. Like name of the note and starting and ending elf_note.

I think user space expects total size and that size is put in PT_NOTE
elf header. Things seem to be fine so far because we are not using
vmcoreinfo note to the maximum capacity. But as it starts filling up,
to capacity, at some point of time, problem will be visible.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/ksysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/ksysfs.c
===================================================================
--- linux-2.6.orig/kernel/ksysfs.c	2014-01-14 14:09:42.107767503 -0500
+++ linux-2.6/kernel/ksysfs.c	2014-01-14 14:15:24.385510314 -0500
@@ -126,7 +126,7 @@ static ssize_t vmcoreinfo_show(struct ko
 {
 	return sprintf(buf, "%lx %x\n",
 		       paddr_vmcoreinfo_note(),
-		       (unsigned int)vmcoreinfo_max_size);
+		       (unsigned int)sizeof(vmcoreinfo_note));
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
