Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaBRWId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:08:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaBRWIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:08:32 -0500
Date: Tue, 18 Feb 2014 17:00:27 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, riel@redhat.com, akpm@linux-foundation.org,
        james.leddy@redhat.com
Subject: [PATCH] fs/proc/meminfo: meminfo_proc_show(): fix typo in comment
Message-ID: <20140218170027.00bcf592@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should read "reclaimable slab" and not "reclaimable swap".

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 fs/proc/meminfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 136e548..7445af0 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -73,7 +73,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	available += pagecache;
 
 	/*
-	 * Part of the reclaimable swap consists of items that are in use,
+	 * Part of the reclaimable slab consists of items that are in use,
 	 * and cannot be freed. Cap this estimate at the low watermark.
 	 */
 	available += global_page_state(NR_SLAB_RECLAIMABLE) -
-- 
1.8.1.4

