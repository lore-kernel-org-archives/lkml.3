Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966978AbaCUBYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:24:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760342AbaCUADf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>, arc-linux-dev@synopsys.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 043/149] ARC: Use correct PTAG register for icache flush
Date: Thu, 20 Mar 2014 17:03:26 -0700
Message-Id: <20140321000438.458635608@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit b053940df41808f0f27568eb36820d10a8a987f8 upstream.

This fixes a subtle issue with cache flush which could potentially cause
random userspace crashes because of stale icache lines.

This error crept in when consolidating the cache flush code

Fixes: bd12976c3664 (ARC: cacheflush refactor #3: Unify the {d,i}cache)
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: arc-linux-dev@synopsys.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/mm/cache_arc700.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -282,7 +282,7 @@ static inline void __cache_line_loop(uns
 #else
 	/* if V-P const for loop, PTAG can be written once outside loop */
 	if (full_page_op)
-		write_aux_reg(ARC_REG_DC_PTAG, paddr);
+		write_aux_reg(aux_tag, paddr);
 #endif
 
 	while (num_lines-- > 0) {
@@ -296,7 +296,7 @@ static inline void __cache_line_loop(uns
 		write_aux_reg(aux_cmd, vaddr);
 		vaddr += L1_CACHE_BYTES;
 #else
-		write_aux_reg(aux, paddr);
+		write_aux_reg(aux_cmd, paddr);
 		paddr += L1_CACHE_BYTES;
 #endif
 	}


