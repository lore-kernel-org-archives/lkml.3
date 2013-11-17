Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3KQQbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:31:49 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27677 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3KQQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:31:41 -0500
X-IronPort-AV: E=Sophos;i="4.93,718,1378857600"; 
   d="scan'208";a="72823486"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <stefano.stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/arm: p2m_init and p2m_lock should be static
Date: Sun, 17 Nov 2013 16:31:34 +0000
Message-ID: <1384705894-8285-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/p2m.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
index 0f842e8..b31ee1b2 100644
--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -25,7 +25,7 @@ struct xen_p2m_entry {
 	struct rb_node rbnode_phys;
 };
 
-rwlock_t p2m_lock;
+static rwlock_t p2m_lock;
 struct rb_root phys_to_mach = RB_ROOT;
 EXPORT_SYMBOL_GPL(phys_to_mach);
 static struct rb_root mach_to_phys = RB_ROOT;
@@ -201,7 +201,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 }
 EXPORT_SYMBOL_GPL(__set_phys_to_machine);
 
-int p2m_init(void)
+static int p2m_init(void)
 {
 	rwlock_init(&p2m_lock);
 	return 0;
-- 
1.7.2.5

