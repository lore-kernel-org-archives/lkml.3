Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3JMQgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:36:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45238 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab3JMQgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:36:40 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, microcode: Correct kconfig dependencies
Date: Sun, 13 Oct 2013 18:36:29 +0200
Message-Id: <1381682189-14470-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

I have a randconfig here which has enabled only

 CONFIG_MICROCODE=y
 CONFIG_MICROCODE_OLD_INTERFACE=y

with both

 # CONFIG_MICROCODE_INTEL is not set
 # CONFIG_MICROCODE_AMD is not set

off. Which makes building the microcode functionality a little
pointless. Don't do that in such cases then.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8076f1d9e4e7..945492c9b285 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1071,6 +1071,7 @@ config X86_REBOOTFIXUPS
 
 config MICROCODE
 	tristate "CPU microcode loading support"
+	depends on CPU_SUP_AMD || CPU_SUP_INTEL
 	select FW_LOADER
 	---help---
 
-- 
1.8.4

