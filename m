Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3FPTdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 15:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab3FPTdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 15:33:20 -0400
Date: Sun, 16 Jun 2013 15:32:44 -0400
From: Kyle McMartin <kyle@redhat.com>
To: catalin.marinas@arm.com
Cc: will.deacon@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm64/Makefile: provide vdso_install target
Message-ID: <20130616193243.GC8939@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a vdso_install target in the arm64 Makefile, as other architectures
with a vdso do.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -60,6 +60,10 @@ zinstall install: vmlinux
 dtbs: scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts dtbs
 
+PHONY += vdso_install
+vdso_install:
+	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso $@
+
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
