Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162Ab3HSJ6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:58:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37600 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3HSJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:58:17 -0400
Date: Mon, 19 Aug 2013 02:55:53 -0700
From: tip-bot for Raghavendra K T <tipbot@zytor.com>
Message-ID: <tip-36bd621337c91a1ecda588e5bbbae8dd9698bae7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        trivial@kernel.org, gleb@redhat.com, raghavendra.kt@linux.vnet.ibm.com,
        pbonzini@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org, gleb@redhat.com, raghavendra.kt@linux.vnet.ibm.com,
        pbonzini@redhat.com, tglx@linutronix.de
In-Reply-To: <1376645921-8056-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1376645921-8056-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86/kvm/guest: Fix sparse warning: "symbol '
 klock_waiting' was not declared as static"
Git-Commit-ID: 36bd621337c91a1ecda588e5bbbae8dd9698bae7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 19 Aug 2013 02:56:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36bd621337c91a1ecda588e5bbbae8dd9698bae7
Gitweb:     http://git.kernel.org/tip/36bd621337c91a1ecda588e5bbbae8dd9698bae7
Author:     Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
AuthorDate: Fri, 16 Aug 2013 15:08:41 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 19 Aug 2013 11:49:50 +0200

x86/kvm/guest: Fix sparse warning: "symbol 'klock_waiting' was not declared as static"

It was not declared as static since it was thought to be used by
pv-flushtlb earlier.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: <gleb@redhat.com>
Cc: <pbonzini@redhat.com>
Cc: Jiri Kosina <trivial@kernel.org>
Link: http://lkml.kernel.org/r/1376645921-8056-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ef630..56e2fa4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -529,7 +529,7 @@ arch_initcall(activate_jump_labels);
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 /* Kick a cpu by its apicid. Used to wake up a halted vcpu */
-void kvm_kick_cpu(int cpu)
+static void kvm_kick_cpu(int cpu)
 {
 	int apicid;
 	unsigned long flags = 0;
