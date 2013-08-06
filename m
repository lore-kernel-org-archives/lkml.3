Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3HFVnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:43:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3HFVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:43:05 -0400
Date: Tue, 6 Aug 2013 14:42:54 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-9e1a431de08e2a49ca8dab0edc813c8cb96ba369@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-3-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage:
  Change dotraplinkage into __visible on 32bit
Git-Commit-ID: 9e1a431de08e2a49ca8dab0edc813c8cb96ba369
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:43:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e1a431de08e2a49ca8dab0edc813c8cb96ba369
Gitweb:     http://git.kernel.org/tip/9e1a431de08e2a49ca8dab0edc813c8cb96ba369
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:36 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:18:17 -0700

x86, asmlinkage: Change dotraplinkage into __visible on 32bit

Mark 32bit dotraplinkage functions as __visible for LTO.
64bit already is using asmlinkage which includes it.

v2: Clean up (M.Marek)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-3-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/traps.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 88eae2a..7036cb6 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -6,11 +6,7 @@
 #include <asm/debugreg.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
-#ifdef CONFIG_X86_32
-#define dotraplinkage
-#else
-#define dotraplinkage asmlinkage
-#endif
+#define dotraplinkage __visible
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
