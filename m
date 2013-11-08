Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab3KHXsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:48:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53208 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab3KHXnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:43:45 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/24] mm/init: Use memblock apis for early memory allocations
Date: Fri, 8 Nov 2013 18:41:46 -0500
Message-ID: <1383954120-24368-11-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
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
 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index af310af..1a95ea2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -346,8 +346,8 @@ static inline void smp_prepare_cpus(unsigned int maxcpus) { }
  */
 static void __init setup_command_line(char *command_line)
 {
-	saved_command_line = alloc_bootmem(strlen (boot_command_line)+1);
-	static_command_line = alloc_bootmem(strlen (command_line)+1);
+	saved_command_line = memblock_virt_alloc(strlen(boot_command_line)+1);
+	static_command_line = memblock_virt_alloc(strlen(command_line)+1);
 	strcpy (saved_command_line, boot_command_line);
 	strcpy (static_command_line, command_line);
 }
-- 
1.7.9.5

