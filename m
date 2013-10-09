Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3JIUvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:51:46 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28260 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab3JIUt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:49:28 -0400
X-IronPort-AV: E=Sophos;i="4.90,1066,1371081600"; 
   d="scan'208";a="62111335"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8 04/17] xen/x86: allow __set_phys_to_machine for autotranslate guests
Date: Wed, 9 Oct 2013 21:48:17 +0100
Message-ID: <1381351710-1876-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow __set_phys_to_machine to be called for autotranslate guests.
It can be used to keep track of phys_to_machine changes, however we
don't do anything with the information at the moment.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/p2m.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 95fb2aa..59d9e70 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -798,10 +798,10 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
 	unsigned topidx, mididx, idx;
 
-	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+	/* don't track P2M changes in autotranslate guests */
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
 		return true;
-	}
+
 	if (unlikely(pfn >= MAX_P2M_PFN)) {
 		BUG_ON(mfn != INVALID_P2M_ENTRY);
 		return true;
-- 
1.7.2.5

