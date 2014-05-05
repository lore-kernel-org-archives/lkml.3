Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaEEWfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:35:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:58940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933030AbaEEW0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:26:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,992,1389772800"; 
   d="scan'208";a="535113718"
From: Andi Kleen <andi@firstfloor.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 20/24] net, diet: Make XPS configurable
Date: Mon,  5 May 2014 15:26:09 -0700
Message-Id: <1399328773-6531-21-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Not needed on small systems. Already disabled with !SMP,
but also makes sense to explicitely disabled on very
small multi-core SOCKs.

Saves ~6k text, but increases the data segment by a
mysterious ~4k (some padding?)

   text	   data	    bss	    dec	    hex	filename
6893698	1392544	 634880	8921122	 882022	vmlinux-with-xps
6887542	1396544	 634880	8918966	 8817b6	vmlinux-wo-xps

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/Kconfig b/net/Kconfig
index cc0264a..2437348 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -259,7 +259,7 @@ config RFS_ACCEL
 	default y
 
 config XPS
-	boolean
+	bool "Support multiqueue transmit queues (XPS)"
 	depends on SMP
 	default y
 
-- 
1.9.0

