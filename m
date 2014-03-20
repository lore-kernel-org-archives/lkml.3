Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbaCTJoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:44:21 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58886 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025AbaCTJoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:44:17 -0400
Subject: [PATCH 33/33] Support check
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:14:06 +0530
Message-ID: <20140320094406.14878.38787.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-9574-0000-0000-00000C888E6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This checks if a particular build can support dumps on 32/64 bit applications.

For eg. A 32bit build of gencore cant support dumps on 64 bit applications.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |   11 +++++++++++
 src/elf64.c    |    2 ++
 2 files changed, 13 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index 98a7146..49af7b3 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -76,6 +76,17 @@ struct core_proc cp;
 /* PID of Daemon */
 int pid_log;
 
+/* Support Check */
+static int support_check(int pid, struct core_proc *cp)
+{
+	gencore_log("This build of gencore(32bit) cannot dump a 64bit process.\n");
+	return -1;
+}
+
+#if defined(__i386) || (defined(__s390__) && !defined(__s390x__)) || (defined(__PPC__) && !defined(__PPC64__))
+#define do_elf64_coredump support_check
+#endif
+
 /* Initialised core process members */
 void init_core(void)
 {
diff --git a/src/elf64.c b/src/elf64.c
index 651f218..11c8c76 100644
--- a/src/elf64.c
+++ b/src/elf64.c
@@ -28,6 +28,7 @@
  * and operations once elf.c is included.
  */
 
+#if defined(__x86_64) || (defined(__s390x__) && defined(__s390__)) || (defined(__PPC64__) && defined(__PPC__))
 #define do_elf_coredump do_elf64_coredump
 
 #define Elf_Ehdr Elf64_Ehdr
@@ -40,3 +41,4 @@
 #define Elf_Addr Elf64_Addr
 
 #include "elf.c"
+#endif

