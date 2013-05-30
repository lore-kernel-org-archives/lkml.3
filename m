Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3E3Nfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:35:34 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10603 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab3E3Nf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:35:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,770,1363132800"; 
   d="scan'208";a="28237209"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <mingo@redhat.com>, <peterz@infradead.org>
Subject: [PATCH v5 2/4] kernel: missing include in cputime.c
Date: Thu, 30 May 2013 14:35:00 +0100
Message-ID: <1369920902-3546-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305301426520.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301426520.4799@kaball.uk.xensource.com>
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

