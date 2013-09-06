Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3IFSI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:08:59 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:45649 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3IFSIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:08:54 -0400
From: Linn Crosetto <linn@hp.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@amacapital.net, daniel.vetter@ffwll.ch, airlied@redhat.com,
        yinghai@kernel.org, jacob.shin@amd.com, penberg@kernel.org,
        js1304@gmail.com, akpm@linux-foundation.org, matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [PATCH 2/3] x86: fix sparse warning in parse_e820_ext()
Date: Fri,  6 Sep 2013 12:06:56 -0600
Message-Id: <1378490817-23272-3-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1378490817-23272-1-git-send-email-linn@hp.com>
References: <5223CA9C.5020505@zytor.com>
 <1378490817-23272-1-git-send-email-linn@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the call to early_iounmap() with early_memunmap() to eliminate
the following sparse warning:

arch/x86/kernel/e820.c:672:23: sparse: incorrect type in argument 1 (different address spaces)

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 arch/x86/kernel/e820.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 174da5f..06e0c4a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -669,7 +669,7 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-	early_iounmap(sdata, data_len);
+	early_memunmap(sdata, data_len);
 	printk(KERN_INFO "e820: extended physical RAM map:\n");
 	e820_print_map("extended");
 }
-- 
1.7.11.3

