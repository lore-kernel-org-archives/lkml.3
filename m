Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaAISd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:33:26 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34839 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaAISdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:33:17 -0500
X-IronPort-AV: E=Sophos;i="4.95,632,1384300800"; 
   d="scan'208";a="89253906"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <mingo@redhat.com>, <peterz@infradead.org>
Subject: [PATCH v9 2/5] kernel: missing include in cputime.c
Date: Thu, 9 Jan 2014 18:32:13 +0000
Message-ID: <1389292336-9292-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1401091755390.21510@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1401091755390.21510@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

steal_account_process_tick calls paravirt_steal_clock, but paravirt.h is
currently missing amoung the included header files.
Add include asm/paravirt.h.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: mingo@redhat.com
CC: peterz@infradead.org
---
 kernel/sched/cputime.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9994791..951833e 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -5,6 +5,9 @@
 #include <linux/static_key.h>
 #include <linux/context_tracking.h>
 #include "sched.h"
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#endif
 
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-- 
1.7.10.4

