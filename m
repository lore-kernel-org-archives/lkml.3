Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaIPSuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:50:01 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54080 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaIPSt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:49:58 -0400
From: tim.gardner@canonical.com
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jamie Iles <jamie.iles@oracle.com>
Subject: [PATCH 3.17-rc5 ] =?UTF-8?q?scripts/sortextable:=20Suppress=20warning:?= =?UTF-8?q?=20=E2=80=98relocs=5Fsize=E2=80=99=20may=20be=20used=20uninitia?= =?UTF-8?q?lized?=
Date: Tue, 16 Sep 2014 12:49:22 -0600
Message-Id: <1410893362-17128-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

In file included from scripts/sortextable.c:194:0:
scripts/sortextable.c: In function ‘main’:
scripts/sortextable.h:176:3: warning: ‘relocs_size’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   memset(relocs, 0, relocs_size);
   ^
scripts/sortextable.h:106:6: note: ‘relocs_size’ was declared here
  int relocs_size;
      ^
In file included from scripts/sortextable.c:192:0:
scripts/sortextable.h:176:3: warning: ‘relocs_size’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   memset(relocs, 0, relocs_size);
   ^
scripts/sortextable.h:106:6: note: ‘relocs_size’ was declared here
  int relocs_size;
      ^

gcc 4.9.1

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jamie Iles <jamie.iles@oracle.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

Is gcc 4.9 dumber then 4.8 ? gcc 4.8 doesn't produce this warning.

 scripts/sortextable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/sortextable.h b/scripts/sortextable.h
index 8fac3fd..ba87004 100644
--- a/scripts/sortextable.h
+++ b/scripts/sortextable.h
@@ -103,7 +103,7 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
 	Elf_Sym *sort_needed_sym;
 	Elf_Shdr *sort_needed_sec;
 	Elf_Rel *relocs = NULL;
-	int relocs_size;
+	int relocs_size = 0;
 	uint32_t *sort_done_location;
 	const char *secstrtab;
 	const char *strtab;
-- 
2.1.0

