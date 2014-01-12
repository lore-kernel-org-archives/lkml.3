Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaALRqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:46:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaALRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:45:44 -0500
Date: Sun, 12 Jan 2014 09:45:28 -0800
From: tip-bot for Richard Weinberger <tipbot@zytor.com>
Message-ID: <tip-106553aa4ead528b1bab37fb3cc47004a4451acc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        richard@nod.at, tglx@linutronix.de
In-Reply-To: <1389538341-31383-1-git-send-email-richard@nod.at>
References: <1389538341-31383-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] um, x86: Fix vDSO build
Git-Commit-ID: 106553aa4ead528b1bab37fb3cc47004a4451acc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 09:45:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  106553aa4ead528b1bab37fb3cc47004a4451acc
Gitweb:     http://git.kernel.org/tip/106553aa4ead528b1bab37fb3cc47004a4451acc
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Sun, 12 Jan 2014 15:52:21 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 16:47:31 +0100

um, x86: Fix vDSO build

Commit 663b55b9b39 ("x86: Delete non-required instances of include <linux/init.h>")
broke the UML build.

  arch/x86/um/vdso/vdso.S: Assembler messages:
  arch/x86/um/vdso/vdso.S:2: Error: no such instruction: `__initdata'
  arch/x86/um/vdso/vdso.S:9: Error: no such instruction: `__finit'

UML's vDSO needs linux/init.h.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: paul.gortmaker@windriver.com
Link: http://lkml.kernel.org/r/1389538341-31383-1-git-send-email-richard@nod.at
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/um/vdso/vdso.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/um/vdso/vdso.S b/arch/x86/um/vdso/vdso.S
index 4b4bd4c..1cb468a 100644
--- a/arch/x86/um/vdso/vdso.S
+++ b/arch/x86/um/vdso/vdso.S
@@ -1,3 +1,4 @@
+#include <linux/init.h>
 
 __INITDATA
 
