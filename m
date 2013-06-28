Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3F1LVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:21:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30037 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3F1LVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:21:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,958,1363132800"; 
   d="scan'208";a="32429530"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <mingo@redhat.com>, <peterz@infradead.org>
Subject: [PATCH v7 5/6] core: remove ifdef CONFIG_PARAVIRT
Date: Fri, 28 Jun 2013 12:20:46 +0100
Message-ID: <1372418447-24066-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306271614260.4782@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306271614260.4782@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the asm/paravirt.h headers (x86, ia64, arm, arm64) are properly
ifdef'ed CONFIG_PARAVIRT inside so they can be safely included.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: mingo@redhat.com
CC: peterz@infradead.org
---
 kernel/sched/core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..cd339c5 100644
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
1.7.2.5

