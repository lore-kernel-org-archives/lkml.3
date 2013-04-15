Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456Ab3DOIGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:06:42 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46269 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOIGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:06:39 -0400
Date: Mon, 15 Apr 2013 16:06:21 +0800
From: Wang YanQing <udknight@gmail.com>
To: akpm@linux-foundation.org
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: reserve_crashkernel: use
 memblock_is_region_reserved to simplify code
Message-ID: <20130415080621.GA1994@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	akpm@linux-foundation.org, yinghai@kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memblock_is_region_reserved instead of memblock_find_in_range
to simplify the check codes, and gain a little speed benefit.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/kernel/setup.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..9d60c85 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -577,11 +577,7 @@ static void __init reserve_crashkernel(void)
 		}
 
 	} else {
-		unsigned long long start;
-
-		start = memblock_find_in_range(crash_base,
-				 crash_base + crash_size, crash_size, 1<<20);
-		if (start != crash_base) {
+		if (memblock_is_region_reserved(crash_base, crash_size)) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
-- 
1.7.12.4.dirty
