Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3JPGnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:43:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55791 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab3JPGnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:43:40 -0400
Date: Tue, 15 Oct 2013 23:43:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Michael Davidson <md@google.com>, Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] x86, relocs: add percpu fixup for GNU ld 2.23
Message-ID: <20131016064314.GA2739@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GNU linker tries to put __per_cpu_load into the percpu area, resulting
in a lack of its relocation. Force this symbol to be relocated. Seen
starting with GNU ld 2.23 and later.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/tools/relocs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 1fa291f..7a85f29 100644
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
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
