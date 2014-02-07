Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaBGEfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:35:47 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6639 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaBGEfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:35:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Feb 2014 20:33:37 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 1/6] ARM: trusted_foundations: fix vendor prefix typos
Date: Fri, 7 Feb 2014 13:35:01 +0900
Message-ID: <1391747706-1847-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_register_trusted_foundations() and the firmware Kconfig used
the wrong vendor prefix for Trusted Logic Mobility.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/firmware/Kconfig                  | 2 +-
 arch/arm/include/asm/trusted_foundations.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/firmware/Kconfig b/arch/arm/firmware/Kconfig
index bb00ccf00d66..bb126594995e 100644
--- a/arch/arm/firmware/Kconfig
+++ b/arch/arm/firmware/Kconfig
@@ -20,7 +20,7 @@ config TRUSTED_FOUNDATIONS
 	  This option allows the kernel to invoke the secure monitor whenever
 	  required on devices using Trusted Foundations. See
 	  arch/arm/include/asm/trusted_foundations.h or the
-	  tl,trusted-foundations device tree binding documentation for details
+	  tlm,trusted-foundations device tree binding documentation for details
 	  on how to use it.
 
 	  Say n if you don't know what this is about.
diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
index 3bd36e2c5f2e..997862fd5d77 100644
--- a/arch/arm/include/asm/trusted_foundations.h
+++ b/arch/arm/include/asm/trusted_foundations.h
@@ -59,7 +59,7 @@ static inline void of_register_trusted_foundations(void)
 	 * If we find the target should enable TF but does not support it,
 	 * fail as the system won't be able to do much anyway
 	 */
-	if (of_find_compatible_node(NULL, NULL, "tl,trusted-foundations"))
+	if (of_find_compatible_node(NULL, NULL, "tlm,trusted-foundations"))
 		register_trusted_foundations(NULL);
 }
 #endif /* CONFIG_TRUSTED_FOUNDATIONS */
-- 
1.8.5.3

