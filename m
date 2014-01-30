Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaA3GWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:22:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52151 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaA3GWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:22:30 -0500
Date: Wed, 29 Jan 2014 22:22:20 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-07ba06d9d293d3c0a512f1cb9189645c6e0424e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1382458079-24450-8-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-8-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, xen: Fix type of NMI
Git-Commit-ID: 07ba06d9d293d3c0a512f1cb9189645c6e0424e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 29 Jan 2014 22:22:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07ba06d9d293d3c0a512f1cb9189645c6e0424e2
Gitweb:     http://git.kernel.org/tip/07ba06d9d293d3c0a512f1cb9189645c6e0424e2
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 22 Oct 2013 09:07:59 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Jan 2014 22:17:18 -0800

x86, asmlinkage, xen: Fix type of NMI

LTO requires consistent types of symbols over all files.

So "nmi" cannot be declared as a char [] here, need to use the
correct function type.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1382458079-24450-8-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/xen/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 68c054f..518ab4a 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -34,7 +34,7 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 #ifdef CONFIG_X86_64
-extern const char nmi[];
+extern asmlinkage void nmi(void);
 #endif
 extern void xen_sysenter_target(void);
 extern void xen_syscall_target(void);
@@ -559,7 +559,7 @@ void xen_enable_syscall(void)
 void xen_enable_nmi(void)
 {
 #ifdef CONFIG_X86_64
-	if (register_callback(CALLBACKTYPE_nmi, nmi))
+	if (register_callback(CALLBACKTYPE_nmi, (char *)nmi))
 		BUG();
 #endif
 }
