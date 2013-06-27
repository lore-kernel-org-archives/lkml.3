Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3F0Nzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:55:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13296 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3F0Nyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:54:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,952,1363132800"; 
   d="scan'208";a="33808313"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <catalin.marinas@arm.com>, <arnd@arndb.de>,
        <olof@lixom.net>, <linux@arm.linux.org.uk>, <Ian.Campbell@citrix.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <marc.zyngier@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <mingo@redhat.com>, <peterz@infradead.org>
Subject: [PATCH v6 2/5] kernel: missing include in cputime.c
Date: Thu, 27 Jun 2013 14:54:29 +0100
Message-ID: <1372341272-12512-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306271446570.4782@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306271446570.4782@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

steal_account_process_tick calls paravirt_steal_clock, but paravirt.h is
currently missing amoung the included header files.
Add include asm/paravirt.h ifdef CONFIG_PARAVIRT.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: mingo@redhat.com
CC: peterz@infradead.org

Changes in v5:
- add ifdef CONFIG_PARAVIRT.
---
 kernel/sched/cputime.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index cc2dc3ee..317a578 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -5,7 +5,9 @@
 #include <linux/static_key.h>
 #include <linux/context_tracking.h>
 #include "sched.h"
-
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
-- 
1.7.2.5

