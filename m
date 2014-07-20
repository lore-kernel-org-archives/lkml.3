Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaGTXOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 19:14:04 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:50195 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaGTXOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 19:14:01 -0400
Date: Mon, 21 Jul 2014 01:13:55 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: [PATCH] x86_32, entry: fix sysenter_badsys END symbol
Message-ID: <alpine.LNX.2.11.1407210110550.31021@titan.int.lan.stealer.net>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 1.3
X-Spam-Bar: +
X-Spam-Report: Scanned by SpamAssassin 3.3.2 2011-06-06 on smtp1.stealer.net at Sun, 20 Jul 2014 23:14:00 +0000
 Bayes: 0.0196 Tokens: new, 155; hammy, 4; neutral, 3; spammy, 0.
 AutoLearn: no
 * -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
 *      [score: 0.0196]
 *  1.0 URIBL_RHSMAILPOLICE Contains a URL listed in the
 *      block.rhs.mailpolice.com blocklist
 *      [URIs: stealer.net]
 *  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
X-Spam-Signature: 13ecf6e95d1ad30032cae123b2cc1d4fc05c7929
X-DomainKey-Status: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 793f6c9..0958f2b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -682,7 +682,7 @@ END(syscall_badsys)
 sysenter_badsys:
 	movl $-ENOSYS,%eax
 	jmp sysenter_after_call
-END(syscall_badsys)
+END(sysenter_badsys)
 	CFI_ENDPROC
 
 .macro FIXUP_ESPFIX_STACK
