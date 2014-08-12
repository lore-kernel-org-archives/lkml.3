Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaHLNgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:36:32 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42921 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaHLNg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:36:29 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: tj@kernel.org, cl@linux-foundation.org, linux-mm@kvack.org,
        user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Honggang Li <enjoymindful@gmail.com>
Subject: [PATCH] Free percpu allocation info for uniprocessor system
Date: Tue, 12 Aug 2014 21:36:15 +0800
Message-Id: <1407850575-18794-2-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1407850575-18794-1-git-send-email-enjoymindful@gmail.com>
References: <1407850575-18794-1-git-send-email-enjoymindful@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, only SMP system free the percpu allocation info.
Uniprocessor system should free it too. For example, one x86 UML
virtual machine with 256MB memory, UML kernel wastes one page memory.

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
---
 mm/percpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 2139e30..da997f9 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1932,6 +1932,8 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
+
+	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */
-- 
1.8.3.1

