Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaDZIuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 04:50:51 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:55644 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbaDZIuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 04:50:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUQADNyW1NXQCJ0/2dsb2JhbABZgwaCQKk/AQEDBAGZcQICgQ4XdIJTExwjGIECJBOIRQHLCIVaiH+EQAEDjnuKDwGKcodqgzM7
Date: Sat, 26 Apr 2014 10:52:49 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/vmalloc.c: replace seq_printf by seq_puts
Message-Id: <20140426105249.ffff09378498452cd9664c92@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace seq_printf where possible

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/vmalloc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bf233b2..9e81469 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2619,19 +2619,19 @@ static int s_show(struct seq_file *m, void *p)
 		seq_printf(m, " phys=%llx", (unsigned long long)v->phys_addr);
 
 	if (v->flags & VM_IOREMAP)
-		seq_printf(m, " ioremap");
+		seq_puts(m, " ioremap");
 
 	if (v->flags & VM_ALLOC)
-		seq_printf(m, " vmalloc");
+		seq_puts(m, " vmalloc");
 
 	if (v->flags & VM_MAP)
-		seq_printf(m, " vmap");
+		seq_puts(m, " vmap");
 
 	if (v->flags & VM_USERMAP)
-		seq_printf(m, " user");
+		seq_puts(m, " user");
 
 	if (v->flags & VM_VPAGES)
-		seq_printf(m, " vpages");
+		seq_puts(m, " vpages");
 
 	show_numa_info(m, v);
 	seq_putc(m, '\n');
-- 
1.8.4.5

