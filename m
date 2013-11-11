Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3KKO2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:28:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53568 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab3KKO2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:28:06 -0500
Date: Mon, 11 Nov 2013 15:27:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>
Subject: [PATCH -v1.1] Kbuild: Ignore GREP_OPTIONS env variable
Message-ID: <20131111142743.GE28219@pd.tnic>
References: <20131030160635.GE13290@pd.tnic>
 <527AB7D1.9080307@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <527AB7D1.9080307@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] Kbuild: Ignore GREP_OPTIONS env variable

When building the kernel in a shell which defines GREP_OPTIONS so that
grep behavior is modified, we can break the generation of the syscalls
table like so:

__SYSCALL_COMMON([01;31m[K0[m[K, sys_read, sys_read)
__SYSCALL_COMMON([01;31m[K1[m[K, sys_write, sys_write)
__SYSCALL_COMMON([01;31m[K1[m[K0, sys_mprotect, sys_mprotect) ...

This is just the initial breakage, later we barf when generating
modules.

In this case, GREP_OPTIONS contains "--color=always" which adds the shell
colors markup and completely fudges the headers under ...generated/asm/.

Fix that by unexporting the GREP_OPTIONS variable for the whole kernel
build as we tend to use grep at a bunch of places.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 868c0eb67b08..73503a7755fd 100644
--- a/Makefile
+++ b/Makefile
@@ -22,6 +22,9 @@ LC_COLLATE=C
 LC_NUMERIC=C
 export LC_COLLATE LC_NUMERIC
 
+# Avoid interference with shell env settings
+unexport GREP_OPTIONS
+
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.
 #
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
