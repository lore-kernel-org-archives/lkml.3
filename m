Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab3JRNVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:21:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3JRNVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:21:00 -0400
Date: Fri, 18 Oct 2013 06:20:47 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-aec58bafaf89279522c44ec8ca9211eabb2b6976@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dinggnu@gmail.com, keescook@chromium.org, md@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, dinggnu@gmail.com, md@google.com,
        tglx@linutronix.de
In-Reply-To: <20131016064314.GA2739@www.outflux.net>
References: <20131016064314.GA2739@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86/relocs: Add percpu fixup for GNU ld 2.23
Git-Commit-ID: aec58bafaf89279522c44ec8ca9211eabb2b6976
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 18 Oct 2013 06:20:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aec58bafaf89279522c44ec8ca9211eabb2b6976
Gitweb:     http://git.kernel.org/tip/aec58bafaf89279522c44ec8ca9211eabb2b6976
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue, 15 Oct 2013 23:43:14 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Oct 2013 08:45:09 +0200

x86/relocs: Add percpu fixup for GNU ld 2.23

The GNU linker tries to put __per_cpu_load into the percpu area,
resulting in a lack of its relocation. Force this symbol to be
relocated. Seen starting with GNU ld 2.23 and later.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michael Davidson <md@google.com>
Cc: Cong Ding <dinggnu@gmail.com>
Link: http://lkml.kernel.org/r/20131016064314.GA2739@www.outflux.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/tools/relocs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 71a2533..11f9285 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -729,6 +729,7 @@ static void percpu_init(void)
  *
  * The GNU linker incorrectly associates:
  *	__init_begin
+ *	__per_cpu_load
  *
  * The "gold" linker incorrectly associates:
  *	init_per_cpu__irq_stack_union
@@ -738,6 +739,7 @@ static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
 {
 	return (sym->st_shndx == per_cpu_shndx) &&
 		strcmp(symname, "__init_begin") &&
+		strcmp(symname, "__per_cpu_load") &&
 		strncmp(symname, "init_per_cpu_", 13);
 }
 
