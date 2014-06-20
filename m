Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966761AbaFTScF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:32:05 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50518 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087AbaFTScC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:32:02 -0400
X-IronPort-AV: E=Sophos;i="5.01,515,1400050800"; 
   d="scan'208";a="35193174"
From: Markus Mayer <markus.mayer@linaro.org>
To: Michal Marek <mmarek@suse.cz>
CC: Linux Build List <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/2] Makefile: Introduce HOSTLDFLAGS environment variable
Date: Fri, 20 Jun 2014 11:31:29 -0700
Message-ID: <1403289089-11299-3-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403289089-11299-1-git-send-email-markus.mayer@linaro.org>
References: <1403289089-11299-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default we don't need HOSTLDFLAGS. However, providing it gives the
user the ability to pass extra flags to the host linker should they be
required.

The variables AS LD CC are moved to the next line to keep line length
in check.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 5795eea..f6e2f53 100644
--- a/Makefile
+++ b/Makefile
@@ -414,8 +414,8 @@ KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
 KERNELVERSION = $(VERSION)$(if $(PATCHLEVEL),.$(PATCHLEVEL)$(if $(SUBLEVEL),.$(SUBLEVEL)))$(EXTRAVERSION)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
-export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP
+export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS HOSTLDFLAGS CROSS_COMPILE
+export AS LD CC CPP AR NM STRIP OBJCOPY OBJDUMP
 export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
-- 
1.9.1

