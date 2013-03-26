Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909Ab3CZPWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab3CZPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 030/150] powerpc: Fix STAB initialization
Date: Tue, 26 Mar 2013 15:18:49 +0000
Message-Id: <1364311249-14454-31-git-send-email-luis.henriques@canonical.com>
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

commit 13938117a57f88a22f0df9722a5db7271fda85cd upstream.

Commit f5339277eb8d3aed37f12a27988366f68ab68930 accidentally removed
more than just iSeries bits and took out the call to stab_initialize()
thus breaking support for POWER3 processors.

Put it back. (Yes, nobody noticed until now ...)

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/mm/hash_utils_64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 377e5cb..15972e2 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -759,6 +759,8 @@ void __init early_init_mmu(void)
 	/* Initialize stab / SLB management */
 	if (mmu_has_feature(MMU_FTR_SLB))
 		slb_initialize();
+	else
+		stab_initialize(get_paca()->stab_real);
 }
 
 #ifdef CONFIG_SMP
-- 
1.8.1.2

