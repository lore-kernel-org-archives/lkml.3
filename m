Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3J2SIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3J2SIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 61/81] sparc64: Fix off by one in trampoline TLB mapping installation loop.
Date: Tue, 29 Oct 2013 11:04:22 -0700
Message-Id: <1383069882-11437-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 63d499662aeec1864ec36d042aca8184ea6a938e ]

Reported-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.1.2

