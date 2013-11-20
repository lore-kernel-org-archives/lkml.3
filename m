Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3KTRyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:54:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3KTRwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:52:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/6] kexec: Export vmcoreinfo note size properly
Date: Wed, 20 Nov 2013 12:50:46 -0500
Message-Id: <1384969851-7251-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we seem to be exporting the max data size contained inside
vmcoreinfo note. But this does not include the size of meta data around
vmcore info data. Like name of the note and starting and ending elf_note.

I think user space expects total size and that size is put in PT_NOTE
elf header.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/ksysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 9659d38..d945a94 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -126,7 +126,7 @@ static ssize_t vmcoreinfo_show(struct kobject *kobj,
 {
 	return sprintf(buf, "%lx %x\n",
 		       paddr_vmcoreinfo_note(),
-		       (unsigned int)vmcoreinfo_max_size);
+		       (unsigned int)sizeof(vmcoreinfo_note));
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
-- 
1.7.7.6

