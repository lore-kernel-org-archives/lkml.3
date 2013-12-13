Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3LMCLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:24 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:59077 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3LMCKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:52 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Kees Cook <keescook@chromium.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 13/14] x86/xen: remove depends on CONFIG_EXPERIMENTAL
Date: Thu, 12 Dec 2013 21:10:20 -0500
Message-Id: <1386900621-27528-14-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Kconfig |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 4d890c3..47316b9 100644
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
1.7.7.6

