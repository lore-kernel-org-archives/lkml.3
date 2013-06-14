Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3FNHbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:31:25 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36076 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3FNHbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:31:20 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 6/8] mm/page_alloc: fix doc for numa_zonelist_order
Date: Fri, 14 Jun 2013 15:30:39 +0800
Message-Id: <1371195041-26654-6-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061407-8256-0000-0000-000007EBEB89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default zonelist order selecter will select "node" order if any node's
DMA zone comprises greater than 70% of its local memory instead of 60%,
according to default_zonelist_order::low_kmem_size > total * 70/100.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 Documentation/sysctl/vm.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index dcc75a9..36ecc26 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -510,7 +510,7 @@ Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
 will select "node" order in following case.
 (1) if the DMA zone does not exist or
 (2) if the DMA zone comprises greater than 50% of the available memory or
-(3) if any node's DMA zone comprises greater than 60% of its local memory and
+(3) if any node's DMA zone comprises greater than 70% of its local memory and
     the amount of local memory is big enough.
 
 Otherwise, "zone" order will be selected. Default order is recommended unless
-- 
1.8.1.2

