Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab3DOJoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:44:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab3DOJoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:44:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,475,1363104000"; 
   d="scan'208";a="7057089"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, yinghai@kernel.org, akpm@linux-foundation.org,
        wency@cn.fujitsu.com, mgorman@suse.de, tj@kernel.org,
        liwanp@linux.vnet.ibm.com
Cc: tangchen@cn.fujitsu.com, linux-mm@kvack.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm: Remove unused parameter of pages_correctly_reserved()
Date: Mon, 15 Apr 2013 17:46:45 +0800
Message-Id: <1366019207-27818-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1366019207-27818-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1366019207-27818-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 17:42:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 17:42:34,
	Serialize complete at 2013/04/15 17:42:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_pages is not used in pages_correctly_reserved().
So remove it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/base/memory.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index a51007b..f926b9c 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -217,8 +217,7 @@ int memory_isolate_notify(unsigned long val, void *v)
  * The probe routines leave the pages reserved, just as the bootmem code does.
  * Make sure they're still that way.
  */
-static bool pages_correctly_reserved(unsigned long start_pfn,
-					unsigned long nr_pages)
+static bool pages_correctly_reserved(unsigned long start_pfn)
 {
 	int i, j;
 	struct page *page;
@@ -266,7 +265,7 @@ memory_block_action(unsigned long phys_index, unsigned long action, int online_t
 
 	switch (action) {
 		case MEM_ONLINE:
-			if (!pages_correctly_reserved(start_pfn, nr_pages))
+			if (!pages_correctly_reserved(start_pfn))
 				return -EBUSY;
 
 			ret = online_pages(start_pfn, nr_pages, online_type);
-- 
1.7.1

