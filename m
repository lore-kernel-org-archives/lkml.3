Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaIEGtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:49:07 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35823 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbaIEGtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:49:01 -0400
From: Robert Richter <rric@kernel.org>
To: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH 6/6] dts, arm: Remove $(MACHINE) variable from dtbs make recipes
Date: Fri,  5 Sep 2014 08:48:12 +0200
Message-Id: <1409899692-1455-7-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1409899692-1455-1-git-send-email-rric@kernel.org>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

The machine description is not needed to build dtb files.

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 4d13c6d0a0cc..422c9aa34382 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -315,10 +315,10 @@ $(BOOT_TARGETS): vmlinux
 PHONY += dtbs dtbs_install
 
 dtbs: prepare scripts
-	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE)
+	$(Q)$(MAKE) $(build)=$(boot)/dts
 
 dtbs_install:
-	$(Q)$(MAKE) $(dtbinst)=$(boot)/dts MACHINE=$(MACHINE)
+	$(Q)$(MAKE) $(dtbinst)=$(boot)/dts
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
-- 
2.0.1

