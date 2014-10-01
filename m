Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaJASqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:46:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaJASqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:46:44 -0400
Date: Wed, 1 Oct 2014 11:46:32 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-20cc28882bf4a8c9a2605a9a76a7952e696aaece@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20141001183632.GA11431@www.outflux.net>
References: <20141001183632.GA11431@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, boot, kaslr:
  Fix nuisance warning on 32-bit builds
Git-Commit-ID: 20cc28882bf4a8c9a2605a9a76a7952e696aaece
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

Commit-ID:  20cc28882bf4a8c9a2605a9a76a7952e696aaece
Gitweb:     http://git.kernel.org/tip/20cc28882bf4a8c9a2605a9a76a7952e696aaece
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Wed, 1 Oct 2014 11:36:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 1 Oct 2014 11:41:24 -0700

x86, boot, kaslr: Fix nuisance warning on 32-bit builds

Building 32-bit threw a warning on kASLR enabled builds:

arch/x86/boot/compressed/aslr.c: In function ‘mem_avoid_overlap’:
arch/x86/boot/compressed/aslr.c:198:17: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   avoid.start = (u64)ptr;
                 ^

This fixes the warning; unsigned long should have been used here.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20141001183632.GA11431@www.outflux.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/aslr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index d39189b..f302dc4 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -195,7 +195,7 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 	while (ptr) {
 		struct mem_vector avoid;
 
-		avoid.start = (u64)ptr;
+		avoid.start = (unsigned long)ptr;
 		avoid.size = sizeof(*ptr) + ptr->len;
 
 		if (mem_overlaps(img, &avoid))
