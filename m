Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaIXPC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:02:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60004 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaIXPC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:02:57 -0400
Date: Wed, 24 Sep 2014 08:02:38 -0700
From: tip-bot for Ben Hutchings <tipbot@zytor.com>
Message-ID: <tip-eeeda4cd06e828b331b15741a204ff9f5874d28d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mt@debian.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ben@decadent.org.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mt@debian.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ben@decadent.org.uk
In-Reply-To: <1411561812.3659.23.camel@decadent.org.uk>
References: <1411561812.3659.23.camel@decadent.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86/relocs: Make per_cpu_load_addr static
Git-Commit-ID: eeeda4cd06e828b331b15741a204ff9f5874d28d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eeeda4cd06e828b331b15741a204ff9f5874d28d
Gitweb:     http://git.kernel.org/tip/eeeda4cd06e828b331b15741a204ff9f5874d28d
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Wed, 24 Sep 2014 13:30:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 15:17:47 +0200

x86/relocs: Make per_cpu_load_addr static

per_cpu_load_addr is only used for 64-bit relocations, but is
declared in both configurations of relocs.c - with different
types.  This has undefined behaviour in general.  GNU ld is
documented to use the larger size in this case, but other tools
may differ and some warn about this.

References: https://bugs.debian.org/748577
Reported-by: Michael Tautschnig <mt@debian.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: 748577@bugs.debian.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1411561812.3659.23.camel@decadent.org.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/tools/relocs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index bbb1d22..a5efb21 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -695,7 +695,7 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
  *
  */
 static int per_cpu_shndx	= -1;
-Elf_Addr per_cpu_load_addr;
+static Elf_Addr per_cpu_load_addr;
 
 static void percpu_init(void)
 {
