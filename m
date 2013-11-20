Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3KTEXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:23:07 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60044 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3KTEWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:22:32 -0500
Subject: [PATCH -tip v3 15/23] x86/alternative: Use NOKPROBE_SYMBOL macro in
 alternative.c
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Nov 2013 04:22:26 +0000
Message-ID: <20131120042226.15296.68207.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from kprobes
instead of __kprobes annotation in alternative.c.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/alternative.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df94598..7cfd6d7 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -551,7 +551,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
  *
  * Note: Must be called under text_mutex.
  */
-void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+void *text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
@@ -585,6 +585,7 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	local_irq_restore(flags);
 	return addr;
 }
+NOKPROBE_SYMBOL(text_poke);
 
 static void do_sync_core(void *info)
 {


