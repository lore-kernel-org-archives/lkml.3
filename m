Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982Ab3CZQRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:17:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964885Ab3CZPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 031/150] powerpc: Fix cputable entry for 970MP rev 1.0
Date: Tue, 26 Mar 2013 15:18:50 +0000
Message-Id: <1364311249-14454-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit d63ac5f6cf31c8a83170a9509b350c1489a7262b upstream.

Commit 44ae3ab3358e962039c36ad4ae461ae9fb29596c forgot to update
the entry for the 970MP rev 1.0 processor when moving some CPU
features bits to the MMU feature bit mask. This breaks booting
on some rare G5 models using that chip revision.

Reported-by: Phileas Fogg <phileas-fogg@mail.ru>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/cputable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 455faa3..31a3dd0 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -269,7 +269,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.cpu_features		= CPU_FTRS_PPC970,
 		.cpu_user_features	= COMMON_USER_POWER4 |
 			PPC_FEATURE_HAS_ALTIVEC_COMP,
-		.mmu_features		= MMU_FTR_HPTE_TABLE,
+		.mmu_features		= MMU_FTRS_PPC970,
 		.icache_bsize		= 128,
 		.dcache_bsize		= 128,
 		.num_pmcs		= 8,
-- 
1.8.1.2

