Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaK0Iq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:41157 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbaK0IqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:25 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Honggang Li <enjoymindful@gmail.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 11/91] percpu: free percpu allocation info for uniprocessor system
Date: Thu, 27 Nov 2014 16:41:54 +0800
Message-Id: <1417077794-9299-11-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Honggang Li <enjoymindful@gmail.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 3189eddbcafcc4d827f7f19facbeddec4424eba8 upstream.

Currently, only SMP system free the percpu allocation info.
Uniprocessor system should free it too. For example, one x86 UML
virtual machine with 256MB memory, UML kernel wastes one page memory.

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/percpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 13b2eef..5f6042b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1907,6 +1907,8 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
+
+	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */
-- 
1.9.1

