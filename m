Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbaEEWeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:34:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:58940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbaEEW0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,992,1389772800"; 
   d="scan'208";a="535113717"
From: Andi Kleen <andi@firstfloor.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 19/24] net, diet: Make RPS configurable
Date: Mon,  5 May 2014 15:26:08 -0700
Message-Id: <1399328773-6531-20-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Multiple receive queues are not needed on small systems,
so allow disabling them.

This is already disabled with !SMP, but it also makes
sense to disable on very small SMP systems (like
dual core SOC)

Can be worth ~30k code and 6k data

   text	   data	    bss	    dec	    hex	filename
6923914	1398176	 634880	8956970	 88ac2a	vmlinux-with-rps
6893698	1392544	 634880	8921122	 882022	vmlinux-wo-rps

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/Kconfig b/net/Kconfig
index fe6e856..cc0264a 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -248,7 +248,7 @@ source "net/mpls/Kconfig"
 source "net/hsr/Kconfig"
 
 config RPS
-	boolean
+	bool "Support multiqueue input queues (RPS)"
 	depends on SMP && SYSFS
 	default y
 
-- 
1.9.0

