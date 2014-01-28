Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaA1WDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:03:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32788 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbaA1WDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:03:45 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] memblock: Add limit checking to memblock_virt_alloc
Date: Tue, 28 Jan 2014 14:04:25 -0800
Message-Id: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In original bootmem wrapper for memblock, we have limit checking.

Add it to memblock_virt_alloc, to address arm and x86 booting crash.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/memblock.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -1077,6 +1077,9 @@ static void * __init memblock_virt_alloc
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
+	if (max_addr > memblock.current_limit)
+		max_addr = memblock.current_limit;
+
 again:
 	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
 					    nid);
