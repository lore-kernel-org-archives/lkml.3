Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaHVXhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:37:41 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:65356 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaHVXhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:37:40 -0400
From: Michael Welling <mwelling@ieee.org>
To: vgoyal@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc: Michael Welling <mwelling@ieee.org>
Subject: [PATCH] purgatory: add clean-up for purgatory directory
Date: Fri, 22 Aug 2014 18:37:10 -0500
Message-Id: <1408750630-11573-1-git-send-email-mwelling@ieee.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch the kexec-purgatory.c and purgatory.ro files are not removed after make mrproper.

Signed-off-by: Michael Welling <mwelling@ieee.org>
---
 arch/x86/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index c96bcec..60087ca 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -251,6 +251,7 @@ archclean:
 	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
+	$(Q)$(MAKE) $(clean)=arch/x86/purgatory
 
 PHONY += kvmconfig
 kvmconfig:
-- 
1.7.9.5

