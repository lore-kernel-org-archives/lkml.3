Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763236Ab3IDRTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:19:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56562 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763209Ab3IDRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:19:03 -0400
Date: Wed, 4 Sep 2013 10:18:45 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-f2a7b303d6e0bfb75b611b560af218608e50011f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        ak@linux.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        ak@linux.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com>
References: <CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, paravirt:
  Remove duplicate definition for DEF_NATIVE
Git-Commit-ID: f2a7b303d6e0bfb75b611b560af218608e50011f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 04 Sep 2013 10:18:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2a7b303d6e0bfb75b611b560af218608e50011f
Gitweb:     http://git.kernel.org/tip/f2a7b303d6e0bfb75b611b560af218608e50011f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 4 Sep 2013 09:43:30 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 4 Sep 2013 09:46:43 -0700

x86, paravirt: Remove duplicate definition for DEF_NATIVE

DEF_NATIVE() is defined in paravirt_types.h, remove duplicate
definition in paravirt.c

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Andi Kleen <ak@linux.kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/CA%2B55aFxVv==DC0JdS87V%2BcPr-twN%2BTujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com
---
 arch/x86/kernel/paravirt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 884aa40..1b10af8 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -62,11 +62,6 @@ void __init default_banner(void)
 	       pv_info.name);
 }
 
-/* Simple instruction patching code. */
-#define DEF_NATIVE(ops, name, code)					\
-	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
-	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
-
 /* Undefined instruction for dealing with missing ops pointers. */
 static const unsigned char ud2a[] = { 0x0f, 0x0b };
 
