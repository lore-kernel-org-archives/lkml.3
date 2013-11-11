Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3KKOf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:35:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab3KKOfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:35:52 -0500
Date: Mon, 11 Nov 2013 09:08:15 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lib/cpumask: Make CPUMASK_OFFSTACK usable without debug
 dependency
Message-ID: <20131111140815.GB20328@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPUMASK_OFFSTACK was added in 2008, it was dependent upon
DEBUG_PER_CPU_MAPS being enabled, or an architecture could select it.
The debug dependency adds additional overhead that isn't required for
operation of the feature, and we need CPUMASK_OFFSTACK to increase the
NR_CPUS value beyond 512 on x86.  We drop the current dependency and make
sure SMP is set.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 lib/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index b3c8be0..50b47cd 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -342,7 +342,8 @@ config CHECK_SIGNATURE
 	bool
 
 config CPUMASK_OFFSTACK
-	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	bool "Force CPU masks off stack"
+	depends on SMP
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
-- 
1.8.3.1

