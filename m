Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaAXVTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:19:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:31341 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbaAXVTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:19:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,715,1384329600"; 
   d="scan'208";a="470432322"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] x86, microcode: Do Intel microcode revision check signed v2
Date: Fri, 24 Jan 2014 13:18:58 -0800
Message-Id: <1390598339-18740-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The Intel SDM Vol 3 9.11.1 Microcode update states that
the update revision field is signed. However we do the comparison
unsigned, as the comparison gets promoted. Change the field
to be signed, so that comparision is really signed.

v2: Change field.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/microcode_intel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 9067166..ed1884b 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -5,7 +5,7 @@
 
 struct microcode_header_intel {
 	unsigned int            hdrver;
-	unsigned int            rev;
+	int	                rev;
 	unsigned int            date;
 	unsigned int            sig;
 	unsigned int            cksum;
-- 
1.8.3.1

