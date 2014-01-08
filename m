Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbaAHSvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:51:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50149 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbaAHSu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:50:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,625,1384300800"; 
   d="scan'208";a="88846949"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8 5/6] core: remove ifdef CONFIG_PARAVIRT
Date: Wed, 8 Jan 2014 18:49:57 +0000
Message-ID: <1389206998-27875-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the asm/paravirt.h headers (x86, ia64, arm, arm64) are properly
ifdef'ed CONFIG_PARAVIRT inside so they can be safely included.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 kernel/sched/core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a4..4f9b239 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -78,9 +78,7 @@
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 #include <asm/mutex.h>
-#ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-#endif
 
 #include "sched.h"
 #include "../workqueue_internal.h"
-- 
1.7.10.4

