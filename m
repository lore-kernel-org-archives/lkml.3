Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3FLWWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:22:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3FLWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:22:48 -0400
Date: Wed, 12 Jun 2013 15:21:30 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-b1983b0a7578de09211a696802edab83fd253303@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, md@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, md@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130611185652.GA23674@www.outflux.net>
References: <20130611185652.GA23674@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, relocs:
  Move __vvar_page from S_ABS to S_REL
Git-Commit-ID: b1983b0a7578de09211a696802edab83fd253303
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 12 Jun 2013 15:21:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1983b0a7578de09211a696802edab83fd253303
Gitweb:     http://git.kernel.org/tip/b1983b0a7578de09211a696802edab83fd253303
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue, 11 Jun 2013 11:56:52 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 12 Jun 2013 15:14:57 -0700

x86, relocs: Move __vvar_page from S_ABS to S_REL

The __vvar_page relocation should actually be listed in S_REL instead
of S_ABS. Oddly, this didn't always cause things to break, presumably
because there are no users for relocation information on 64 bits yet.

[ hpa: Not for stable - new code in 3.10 ]

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130611185652.GA23674@www.outflux.net
Reported-by: Michael Davidson <md@google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/tools/relocs.c | 4 +---
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
