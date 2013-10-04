Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3JDKco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:32:44 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:32810 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3JDKcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:32:42 -0400
Subject: [PATCH 15/19] Calculate the size of the core file
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
Date: Fri, 04 Oct 2013 16:02:34 +0530
Message-ID: <20131004103233.1612.24086.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-2000-0000-0000-00000DFA48B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Calculate the size of the core file

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/gencore-elf.c |    6 ++++++
 fs/proc/gencore.h     |    1 +
 2 files changed, 7 insertions(+)

diff --git a/fs/proc/gencore-elf.c b/fs/proc/gencore-elf.c
index 6e97f6a..efd1722 100644
--- a/fs/proc/gencore-elf.c
+++ b/fs/proc/gencore-elf.c
@@ -291,6 +291,9 @@ static int create_elf_header(struct core_proc *cp)
 						dataoff, cp->nphdrs);
 		dataoff += sizeof(struct elf_shdr);
 	}
+
+	cp->size = dataoff;
+
 	/* Store the notes */
 	tinfo = cp->tinfo;
 	do {
@@ -351,6 +354,9 @@ ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 			buffer += bcp;
 		}
 	}
+	if (*fpos > cp->size)
+		goto out;
+  
 out:
 	return ret;
 }
diff --git a/fs/proc/gencore.h b/fs/proc/gencore.h
index e508417..f6822f2 100644
--- a/fs/proc/gencore.h
+++ b/fs/proc/gencore.h
@@ -30,6 +30,7 @@ struct core_proc {
 	size_t elf_buflen;      /* size of elf_buf */
 	size_t nphdrs;          /* number of phdrs */
 	size_t notes_size;
+	size_t size;
 };
 
 #ifdef CORE_DUMP_USE_REGSET

