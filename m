Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3LET0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:26:21 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:50360 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3LET0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:26:20 -0500
Date: Thu, 5 Dec 2013 20:30:50 +0100
From: Sima Baymani <sima.baymani@gmail.com>
To: linux-mm@kvack.org, rientjes@google.com
Cc: tangchen@cn.fujitsu.com, akpm@linux-foundation.org, aquini@redhat.com,
        linux-kernel@vger.kernel.org, gang.chen@asianux.com,
        aneesh.kumar@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        kirill.shutemov@linux.intel.com, sjenning@linux.vnet.ibm.com,
        darrick.wong@oracle.com
Subject: [PATCH] mm: Add missing dependency in Kconfig
Message-ID: <20131205193050.GA13476@lovelace>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the following (rand)config warning by adding missing PROC_FS
dependency:
warning: (HWPOISON_INJECT && MEM_SOFT_DIRTY) selects PROC_PAGE_MONITOR
which has unmet direct dependencies (PROC_FS && MMU)

Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Sima Baymani <sima.baymani@gmail.com>
---
 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index eb69f35..723bbe0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -543,7 +543,7 @@ config ZSWAP
 
 config MEM_SOFT_DIRTY
 	bool "Track memory changes"
-	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY
+	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY && PROC_FS
 	select PROC_PAGE_MONITOR
 	help
 	  This option enables memory changes tracking by introducing a
-- 
1.7.10.4

