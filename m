Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081Ab3CRV4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:56:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3CRVG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 36/75] powerpc: Fix STAB initialization
Date: Mon, 18 Mar 2013 14:06:59 -0700
Message-Id: <20130318210512.817944509@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 13938117a57f88a22f0df9722a5db7271fda85cd upstream.

Commit f5339277eb8d3aed37f12a27988366f68ab68930 accidentally removed
more than just iSeries bits and took out the call to stab_initialize()
thus breaking support for POWER3 processors.

Put it back. (Yes, nobody noticed until now ...)

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hash_utils_64.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -758,6 +758,8 @@ void __init early_init_mmu(void)
 	/* Initialize stab / SLB management */
 	if (mmu_has_feature(MMU_FTR_SLB))
 		slb_initialize();
+	else
+		stab_initialize(get_paca()->stab_real);
 }
 
 #ifdef CONFIG_SMP


