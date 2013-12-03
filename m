Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3LCC3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:29:25 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36902 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab3LCC3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:29:20 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 09/23] mm/init: Use memblock apis for early memory allocations
Date: Mon, 2 Dec 2013 21:27:24 -0500
Message-ID: <1386037658-3161-10-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator. No functional change in beahvior than what it is
in current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock
interfaces instead of bootmem wrappers build on top of memblock. And the
archs which still uses bootmem, these new apis just fallback to exiting
bootmem APIs.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 init/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index febc511..934430d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -355,9 +355,9 @@ static inline void smp_prepare_cpus(unsigned int maxcpus) { }
  */
 static void __init setup_command_line(char *command_line)
 {
-	saved_command_line = alloc_bootmem(strlen (boot_command_line)+1);
-	initcall_command_line = alloc_bootmem(strlen (boot_command_line)+1);
-	static_command_line = alloc_bootmem(strlen (command_line)+1);
+	saved_command_line = memblock_virt_alloc(strlen(boot_command_line)+1);
+	initcall_command_line = memblock_virt_alloc(strlen (boot_command_line)+1);
+	static_command_line = memblock_virt_alloc(strlen(command_line)+1);
 	strcpy (saved_command_line, boot_command_line);
 	strcpy (static_command_line, command_line);
 }
-- 
1.7.9.5

