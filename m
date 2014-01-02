Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaABVxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:53:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33117 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaABVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:41 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Subject: [RFC PATCHv3 04/11] dm: Use VMALLOC_TOTAL instead of VMALLCO_END - VMALLOC_START
Date: Thu,  2 Jan 2014 13:53:22 -0800
Message-Id: <1388699609-18214-5-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc already provides a macro to calculat the total vmalloc size,
VMALLOC_TOTAL. Use it.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 drivers/md/dm-bufio.c |    4 ++--
 drivers/md/dm-stats.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 54bdd923..cd677f2 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1736,8 +1736,8 @@ static int __init dm_bufio_init(void)
 	 * Get the size of vmalloc space the same way as VMALLOC_TOTAL
 	 * in fs/proc/internal.h
 	 */
-	if (mem > (VMALLOC_END - VMALLOC_START) * DM_BUFIO_VMALLOC_PERCENT / 100)
-		mem = (VMALLOC_END - VMALLOC_START) * DM_BUFIO_VMALLOC_PERCENT / 100;
+	if (mem > VMALLOC_TOTAL * DM_BUFIO_VMALLOC_PERCENT / 100)
+		mem = VMALLOC_TOTAL * DM_BUFIO_VMALLOC_PERCENT / 100;
 #endif
 
 	dm_bufio_default_cache_size = mem;
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 28a9012..378ffb6 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -80,7 +80,7 @@ static bool __check_shared_memory(size_t alloc_size)
 	if (a >> PAGE_SHIFT > totalram_pages / DM_STATS_MEMORY_FACTOR)
 		return false;
 #ifdef CONFIG_MMU
-	if (a > (VMALLOC_END - VMALLOC_START) / DM_STATS_VMALLOC_FACTOR)
+	if (a > VMALLOC_TOTAL / DM_STATS_VMALLOC_FACTOR)
 		return false;
 #endif
 	return true;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

