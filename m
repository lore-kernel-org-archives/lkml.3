Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab3JQRon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:44:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:38538 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855Ab3JQRoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:44:39 -0400
X-IronPort-AV: E=Sophos;i="4.93,515,1378857600"; 
   d="scan'208";a="61976353"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8 04/19] xen/x86: allow __set_phys_to_machine for autotranslate guests
Date: Thu, 17 Oct 2013 18:43:19 +0100
Message-ID: <1382031814-8782-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
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

