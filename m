Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaJIVDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:03:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaJIVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Honggang Li <enjoymindful@gmail.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 004/163] percpu: free percpu allocation info for uniprocessor system
Date: Thu,  9 Oct 2014 14:00:29 -0700
Message-Id: <1412888588-26755-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggang Li <enjoymindful@gmail.com>

commit 3189eddbcafcc4d827f7f19facbeddec4424eba8 upstream.

Currently, only SMP system free the percpu allocation info.
Uniprocessor system should free it too. For example, one x86 UML
virtual machine with 256MB memory, UML kernel wastes one page memory.

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/percpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 7d6ce15..02a89cb 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1911,6 +1911,8 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
+
+	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */
-- 
1.9.1

