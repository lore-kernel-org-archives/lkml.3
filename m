Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaFPUMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:12:32 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49898 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaFPUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:12:31 -0400
Date: Tue, 17 Jun 2014 01:42:24 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] tile: use ARRAY_SIZE
Message-ID: <20140616201224.GA18320@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARRAY_SIZE is more concise to use when the size of an array is divided
by the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:

// <smpl>
@i@
@@

@@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested.
 arch/tile/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index f3ceb63..86900cc 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -277,7 +277,7 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 		if (fixup_exception(regs))  /* ILL_TRANS or UNALIGN_DATA */
 			return;
 		if (fault_num >= 0 &&
-		    fault_num < sizeof(int_name)/sizeof(int_name[0]) &&
+		    fault_num < ARRAY_SIZE(int_name) &&
 		    int_name[fault_num] != NULL)
 			name = int_name[fault_num];
 		else
-- 
1.9.1

