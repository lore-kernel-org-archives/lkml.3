Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3J2SIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59429 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3J2SIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kirill Tkhai <tkhai@yandex.ru>, David Miller <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 59/81] sparc64: Fix ITLB handler of null page
Date: Tue, 29 Oct 2013 11:04:20 -0700
Message-Id: <1383069882-11437-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

[ Upstream commit 1c2696cdaad84580545a2e9c0879ff597880b1a9 ]

1)Use kvmap_itlb_longpath instead of kvmap_dtlb_longpath.

2)Handle page #0 only, don't handle page #1: bleu -> blu

 (KERNBASE is 0x400000, so #1 does not exist too. But everything
  is possible in the future. Fix to not to have problems later.)

3)Remove unused kvmap_itlb_nonlinear.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/ktlb.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/ktlb.S b/arch/sparc/kernel/ktlb.S
index 0746e5e..fde5a41 100644
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -25,11 +25,10 @@ kvmap_itlb:
 	 */
 kvmap_itlb_4v:
 
-kvmap_itlb_nonlinear:
 	/* Catch kernel NULL pointer calls.  */
 	sethi		%hi(PAGE_SIZE), %g5
 	cmp		%g4, %g5
-	bleu,pn		%xcc, kvmap_dtlb_longpath
+	blu,pn		%xcc, kvmap_itlb_longpath
 	 nop
 
 	KERN_TSB_LOOKUP_TL1(%g4, %g6, %g5, %g1, %g2, %g3, kvmap_itlb_load)
-- 
1.8.1.2

