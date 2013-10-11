Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab3JKKwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:52:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab3JKKny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 073/100] sparc64: Fix off by one in trampoline TLB mapping installation loop.
Date: Fri, 11 Oct 2013 11:41:43 +0100
Message-Id: <1381488130-30235-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 63d499662aeec1864ec36d042aca8184ea6a938e upstream.

Reported-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/kernel/trampoline_64.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index da1b781..8fa84a3 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -131,7 +131,6 @@ startup_continue:
 	clr		%l5
 	sethi		%hi(num_kernel_image_mappings), %l6
 	lduw		[%l6 + %lo(num_kernel_image_mappings)], %l6
-	add		%l6, 1, %l6
 
 	mov		15, %l7
 	BRANCH_IF_ANY_CHEETAH(g1,g5,2f)
@@ -224,7 +223,6 @@ niagara_lock_tlb:
 	clr		%l5
 	sethi		%hi(num_kernel_image_mappings), %l6
 	lduw		[%l6 + %lo(num_kernel_image_mappings)], %l6
-	add		%l6, 1, %l6
 
 1:
 	mov		HV_FAST_MMU_MAP_PERM_ADDR, %o5
-- 
1.8.3.2

