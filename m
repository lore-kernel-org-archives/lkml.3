Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768Ab3FUA3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:29:17 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46705 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422749Ab3FUA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:29:15 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v5 5/6] mm/thp: fix doc for transparent huge zero page
Date: Fri, 21 Jun 2013 08:28:53 +0800
Message-Id: <1371774534-4139-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371774534-4139-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371774534-4139-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062100-5490-0000-0000-000003AF35D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transparent huge zero page is used during the page fault instead of
in khugepaged.

# ls /sys/kernel/mm/transparent_hugepage/
defrag  enabled  khugepaged  use_zero_page
# ls /sys/kernel/mm/transparent_hugepage/khugepaged/
alloc_sleep_millisecs  defrag  full_scans  max_ptes_none  pages_collapsed  pages_to_scan  scan_sleep_millisecs

This patch corrects the documentation just like the codes done.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 Documentation/vm/transhuge.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/transhuge.txt b/Documentation/vm/transhuge.txt
index 8785fb8..4a63953 100644
--- a/Documentation/vm/transhuge.txt
+++ b/Documentation/vm/transhuge.txt
@@ -120,8 +120,8 @@ By default kernel tries to use huge zero page on read page fault.
 It's possible to disable huge zero page by writing 0 or enable it
 back by writing 1:
 
-echo 0 >/sys/kernel/mm/transparent_hugepage/khugepaged/use_zero_page
-echo 1 >/sys/kernel/mm/transparent_hugepage/khugepaged/use_zero_page
+echo 0 >/sys/kernel/mm/transparent_hugepage/use_zero_page
+echo 1 >/sys/kernel/mm/transparent_hugepage/use_zero_page
 
 khugepaged will be automatically started when
 transparent_hugepage/enabled is set to "always" or "madvise, and it'll
-- 
1.7.5.4

