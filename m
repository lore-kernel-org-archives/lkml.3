Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3CYBRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:17:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34179 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756470Ab3CYBQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:43 -0400
Message-Id: <20130325010526.608940290@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Phileas Fogg <phileas-fogg@mail.ru>
Subject: [ 023/104] powerpc: Fix cputable entry for 970MP rev 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit d63ac5f6cf31c8a83170a9509b350c1489a7262b upstream.

Commit 44ae3ab3358e962039c36ad4ae461ae9fb29596c forgot to update
the entry for the 970MP rev 1.0 processor when moving some CPU
features bits to the MMU feature bit mask. This breaks booting
on some rare G5 models using that chip revision.

Reported-by: Phileas Fogg <phileas-fogg@mail.ru>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/cputable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -268,7 +268,7 @@ static struct cpu_spec __initdata cpu_sp
 		.cpu_features		= CPU_FTRS_PPC970,
 		.cpu_user_features	= COMMON_USER_POWER4 |
 			PPC_FEATURE_HAS_ALTIVEC_COMP,
-		.mmu_features		= MMU_FTR_HPTE_TABLE,
+		.mmu_features		= MMU_FTRS_PPC970,
 		.icache_bsize		= 128,
 		.dcache_bsize		= 128,
 		.num_pmcs		= 8,


