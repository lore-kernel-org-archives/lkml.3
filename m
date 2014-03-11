Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaCKKMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:12:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbaCKKLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:34 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678284"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-mm@kvack.org,
        Bob Liu <lliubbo@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/17] mm: Replace hardcoding of 19 with MAX_NICE.
Date: Tue, 11 Mar 2014 18:09:15 +0800
Message-Id: <53e301a8f762608bb85d8c9d56b85de836564349.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:40,
	Serialize complete at 2014/03/11 18:08:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: linux-mm@kvack.org
cc: Bob Liu <lliubbo@gmail.com>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Mel Gorman <mgorman@suse.de>
cc: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1546655..dcdb6f9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2803,7 +2803,7 @@ static int khugepaged(void *none)
 	struct mm_slot *mm_slot;
 
 	set_freezable();
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	while (!kthread_should_stop()) {
 		khugepaged_do_scan();
-- 
1.8.2.1

