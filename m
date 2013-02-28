Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764Ab3B1V6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:58:12 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60543 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab3B1V6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:58:07 -0500
Date: Thu, 28 Feb 2013 13:56:40 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: [PATCH v2] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130228215640.GA3136@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---

v2:
 - drop EXPERIMENTAL from bool and help text too.

---
 arch/x86/xen/Kconfig |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 93ff4e1..6c5802f 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -52,12 +52,10 @@ config XEN_DEBUG_FS
 	  Enabling this option may incur a significant performance overhead.
 
 config XEN_X86_PVH
-	bool "Support for running as a PVH guest (EXPERIMENTAL)"
-	depends on X86_64 && XEN && EXPERIMENTAL
+	bool "Support for running as a PVH guest"
+	depends on X86_64 && XEN
 	default n
 	help
 	   This option enables support for running as a PVH guest (PV guest
 	   using hardware extensions) under a suitably capable hypervisor.
-	   This option is EXPERIMENTAL because the hypervisor interfaces
-	   which it uses is not yet considered stable therefore backwards and
-	   forwards compatibility is not yet guaranteed.  If unsure, say N.
+	   If unsure, say N.
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
