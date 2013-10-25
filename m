Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3JYKxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:53:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28424 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3JYKxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:53:07 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="64684012"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 04/18] xen/x86: allow __set_phys_to_machine for autotranslate guests
Date: Fri, 25 Oct 2013 11:51:39 +0100
Message-ID: <1382698313-13161-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
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
index a61c7d5..2ae8699 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -799,10 +799,10 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
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

