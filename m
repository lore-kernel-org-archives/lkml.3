Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3FRLeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:34:14 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55205 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab3FRLeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:34:11 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 4/6] mm/page_alloc: fix doc for numa_zonelist_order
Date: Tue, 18 Jun 2013 19:33:40 +0800
Message-Id: <1371555222-22678-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371555222-22678-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371555222-22678-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061811-6102-0000-0000-000003B84FD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v2 - > v3:
   * add Michal's Reviewed-by 

The default zonelist order selecter will select "node" order if any node's
DMA zone comprises greater than 70% of its local memory instead of 60%,
according to default_zonelist_order::low_kmem_size > total * 70/100.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 Documentation/sysctl/vm.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index a5717c3..15d341a 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -531,7 +531,7 @@ Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
 will select "node" order in following case.
 (1) if the DMA zone does not exist or
 (2) if the DMA zone comprises greater than 50% of the available memory or
-(3) if any node's DMA zone comprises greater than 60% of its local memory and
+(3) if any node's DMA zone comprises greater than 70% of its local memory and
     the amount of local memory is big enough.
 
 Otherwise, "zone" order will be selected. Default order is recommended unless
-- 
1.7.5.4

