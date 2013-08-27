Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3H0JjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:39:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31516 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab3H0JjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:39:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,967,1367942400"; 
   d="scan'208";a="8317102"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 04/11] memblock: Introduce memblock_set_current_limit_low() to set lower limit of memblock.
Date: Tue, 27 Aug 2013 17:37:41 +0800
Message-Id: <1377596268-31552-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 17:37:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 17:37:13,
	Serialize complete at 2013/08/27 17:37:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corresponding to memblock_set_current_limit_high(), we introduce memblock_set_current_limit_low()
to set the lowest limit for memblock.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/linux/memblock.h |    9 ++++++++-
 mm/memblock.c            |    5 +++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 40eb18e..cabd685 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -174,6 +174,14 @@ static inline void memblock_dump_all(void)
 }
 
 /**
+ * memblock_set_current_limit_low - Set the current allocation lower limit to
+ *                         allow limiting allocations to what is currently
+ *                         accessible during boot
+ * @limit: New lower limit value (physical address)
+ */
+void memblock_set_current_limit_low(phys_addr_t limit);
+
+/**
  * memblock_set_current_limit_high - Set the current allocation upper limit to
  *                         allow limiting allocations to what is currently
  *                         accessible during boot
@@ -181,7 +189,6 @@ static inline void memblock_dump_all(void)
  */
 void memblock_set_current_limit_high(phys_addr_t limit);
 
-
 /*
  * pfn conversion functions
  *
diff --git a/mm/memblock.c b/mm/memblock.c
index 0dd5387..54c1c2e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -989,6 +989,11 @@ void __init_memblock memblock_trim_memory(phys_addr_t align)
 	}
 }
 
+void __init_memblock memblock_set_current_limit_low(phys_addr_t limit)
+{
+	memblock.current_limit_low = limit;
+}
+
 void __init_memblock memblock_set_current_limit_high(phys_addr_t limit)
 {
 	memblock.current_limit_high = limit;
-- 
1.7.1

