Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab3HNDpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:45:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7071 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759341Ab3HNDpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:47 -0400
X-IronPort-AV: E=Sophos;i="4.89,874,1367942400"; 
   d="scan'208";a="8197194"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Use memblock_set_current_limit() to set limit for memblock.
Date: Wed, 14 Aug 2013 11:44:04 +0800
Message-Id: <1376451844-15682-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/14 11:43:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/14 11:43:52,
	Serialize complete at 2013/08/14 11:43:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In setup_arch() of x86, it set memblock.current_limit directly.
We should use memblock_set_current_limit(). If the implementation
is changed, it is easy to maintain.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..de33798 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1070,7 +1070,7 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	memblock.current_limit = ISA_END_ADDRESS;
+	memblock_set_current_limit(ISA_END_ADDRESS);
 	memblock_x86_fill();
 
 	/*
@@ -1103,7 +1103,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
-- 
1.7.1

