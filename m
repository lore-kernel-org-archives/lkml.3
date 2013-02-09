Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855Ab3BIWIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 17:08:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42474 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760833Ab3BIWIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 17:08:54 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5/5 -v2] x86, head_32: Clear DF much earlier
Date: Sat,  9 Feb 2013 23:08:49 +0100
Message-Id: <1360447729-4256-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <20130209212342.GA5556@pd.tnic>
References: <20130209212342.GA5556@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

All GCC versions expect the direction flag to be cleared (DF=0) so move
this to the default entry point for each core.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 75e96d7e4e5f..8b2a8a824fc6 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -322,10 +322,11 @@ default_entry:
  * debugger if this code is traced. Best to initialize before switching to
  * protected mode.
  */
-
 	pushl $0
 	popfl
 
+	cld				# GCC wants DF=0 at all times
+
 /*
  * New page tables may be in 4Mbyte page mode and may be using the global pages.
  *
@@ -463,7 +464,6 @@ is486:
 	xorl %eax,%eax			# Clear LDT
 	lldt %ax
 
-	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
 	jmp *(initial_code)
 
-- 
1.8.1.3.535.ga923c31

