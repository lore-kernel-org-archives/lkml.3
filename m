Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab3BITxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:53:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35124 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab3BITxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:53:00 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5/5] x86, head_32: Remove an old gcc2 fix
Date: Sat,  9 Feb 2013 20:52:54 +0100
Message-Id: <1360439574-16122-6-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360439574-16122-1-git-send-email-bp@alien8.de>
References: <1360439574-16122-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

gcc2 wants direction flag cleared but we don't support gcc2 anymore. So
drop it. Original patch adding this was:

commit 57d40092c375d2b6d34f814f5fb306967e22c4f5
Author: linus1 <torvalds@linuxfoundation.org>
Date:   Mon Nov 9 12:00:00 1992 -0600

    [PATCH] Linux-0.98.4 (November 9, 1992)
...

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 75e96d7e4e5f..fc56613224c3 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -463,7 +463,6 @@ is486:
 	xorl %eax,%eax			# Clear LDT
 	lldt %ax
 
-	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
 	jmp *(initial_code)
 
-- 
1.8.1.3.535.ga923c31

