Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3ASBTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:19:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:56739 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab3ASBTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:19:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Schwinge <thomas@codesourcery.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [ 01/21] sh: Fix FDPIC binary loader
Date: Fri, 18 Jan 2013 17:19:19 -0800
Message-Id: <20130119010711.210331066@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010710.897187774@linuxfoundation.org>
References: <20130119010710.897187774@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Schwinge <thomas@codesourcery.com>

commit 4a71997a3279a339e7336ea5d0cd27282e2dea44 upstream.

Ensure that the aux table is properly initialized, even when optional features
are missing.  Without this, the FDPIC loader did not work.  This was meant to
be included in commit d5ab780305bb6d60a7b5a74f18cf84eb6ad153b1.

Signed-off-by: Thomas Schwinge <thomas@codesourcery.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/include/asm/elf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sh/include/asm/elf.h
+++ b/arch/sh/include/asm/elf.h
@@ -202,9 +202,9 @@ extern void __kernel_vsyscall;
 	if (vdso_enabled)					\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE);	\
 	else							\
-		NEW_AUX_ENT(AT_IGNORE, 0);
+		NEW_AUX_ENT(AT_IGNORE, 0)
 #else
-#define VSYSCALL_AUX_ENT
+#define VSYSCALL_AUX_ENT	NEW_AUX_ENT(AT_IGNORE, 0)
 #endif /* CONFIG_VSYSCALL */
 
 #ifdef CONFIG_SH_FPU


