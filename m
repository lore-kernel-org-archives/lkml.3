Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936609Ab3DJNyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:54:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59500 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab3DJNyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:54:45 -0400
Date: Wed, 10 Apr 2013 06:54:32 -0700
From: tip-bot for Paul Bolle <tipbot@zytor.com>
Message-ID: <tip-cd69aa6b383c6a6373bff2204190cadf451ebcc3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1363262077.1335.71.camel@x61.thuisdomein>
References: <1363262077.1335.71.camel@x61.thuisdomein>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Re-enable DEBUG_TLBFLUSH for X86_32
Git-Commit-ID: cd69aa6b383c6a6373bff2204190cadf451ebcc3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:54:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd69aa6b383c6a6373bff2204190cadf451ebcc3
Gitweb:     http://git.kernel.org/tip/cd69aa6b383c6a6373bff2204190cadf451ebcc3
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Thu, 14 Mar 2013 12:54:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 14:53:12 +0200

x86/mm: Re-enable DEBUG_TLBFLUSH for X86_32

CONFIG_INVLPG got removed in commit
094ab1db7cb7833cd4c820acd868fc26acf3f08e ("x86, 386 removal:
Remove CONFIG_INVLPG").

That commit left one instance of CONFIG_INVLPG untouched, effectively
disabling DEBUG_TLBFLUSH for X86_32. Since all currently supported
x86 CPUs should now be able to support that option, just drop the entire
sub-dependency.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Link: http://lkml.kernel.org/r/1363262077.1335.71.camel@x61.thuisdomein
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..16f7383 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -131,7 +131,7 @@ config DOUBLEFAULT
 
 config DEBUG_TLBFLUSH
 	bool "Set upper limit of TLB entries to flush one-by-one"
-	depends on DEBUG_KERNEL && (X86_64 || X86_INVLPG)
+	depends on DEBUG_KERNEL
 	---help---
 
 	X86-only for now.
