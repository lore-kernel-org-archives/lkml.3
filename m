Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab3LFVEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:04:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:28043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759Ab3LFVEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:04:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,842,1378882800"; 
   d="scan'208";a="439941161"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] x86, microcode: Do Intel microcode revision check signed
Date: Fri,  6 Dec 2013 13:04:02 -0800
Message-Id: <1386363843-32530-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The Intel SDM Vol 3 9.11.1 Microcode update states that
the update revision field is signed. However we do the comparison
unsigned, as the comparison gets promoted.

Use a cast to really do a signed comparison of the microcode
revision.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/microcode_intel_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/microcode_intel_lib.c b/arch/x86/kernel/microcode_intel_lib.c
index ce69320..68503d1 100644
--- a/arch/x86/kernel/microcode_intel_lib.c
+++ b/arch/x86/kernel/microcode_intel_lib.c
@@ -41,7 +41,7 @@ update_match_cpu(unsigned int csig, unsigned int cpf,
 int
 update_match_revision(struct microcode_header_intel *mc_header, int rev)
 {
-	return (mc_header->rev <= rev) ? 0 : 1;
+	return ((int)mc_header->rev <= rev) ? 0 : 1;
 }
 
 int microcode_sanity_check(void *mc, int print_err)
-- 
1.8.3.1

