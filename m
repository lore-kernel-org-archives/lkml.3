Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3JDKbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:31:23 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57080 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3JDKbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:31:20 -0400
Subject: [PATCH 04/19] Rename compat versions of the reusable core
 generation routines
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
Date: Fri, 04 Oct 2013 16:01:12 +0530
Message-ID: <20131004103112.1612.53039.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-9574-0000-0000-000009EC4056
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Rename the ELF class specific functions reusable for the application core dump
infrastructure. The compat ELF class routines are prepended with compat_ .

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/compat_binfmt_elf.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index a81147e..9a288aa 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -134,6 +134,13 @@ static void cputime_to_compat_timeval(const cputime_t cputime,
 #define init_elf_binfmt		init_compat_elf_binfmt
 #define exit_elf_binfmt		exit_compat_elf_binfmt
 
+/* Rename the functions that may be reused */
+#define fill_elf_header        compat_fill_elf_header
+#define fill_psinfo            compat_fill_psinfo
+#define fill_prstatus          compat_fill_prstatus
+#define fill_extnum_info       compat_fill_extnum_info
+#define fill_auxv_note         compat_fill_auxv_note
+
 /*
  * We share all the actual code with the native (64-bit) version.
  */

