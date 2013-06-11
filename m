Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3FKS5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:57:08 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40736 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3FKS5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:57:05 -0400
Date: Tue, 11 Jun 2013 11:56:52 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Michael Davidson <md@google.com>
Subject: [PATCH] x86, relocs: move __vvar_page from S_ABS to S_REL
Message-ID: <20130611185652.GA23674@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __vvar_page relocation should actually be listed in S_REL instead
of S_ABS. Oddly, this didn't always cause things to break.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Michael Davidson <md@google.com>
---
 arch/x86/tools/relocs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 590be10..f7bab68 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -42,9 +42,6 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"^(xen_irq_disable_direct_reloc$|"
 	"xen_save_fl_direct_reloc$|"
 	"VDSO|"
-#if ELF_BITS == 64
-	"__vvar_page|"
-#endif
 	"__crc_)",
 
 /*
@@ -72,6 +69,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__per_cpu_load|"
 	"init_per_cpu__.*|"
 	"__end_rodata_hpage_align|"
+	"__vvar_page|"
 #endif
 	"_end)$"
 };
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
