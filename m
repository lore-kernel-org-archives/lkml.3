Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235Ab3HJQNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:13:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33022 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934455Ab3HJQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:13:49 -0400
Date: Sat, 10 Aug 2013 09:13:28 -0700
From: tip-bot for Raghavendra K T <tipbot@zytor.com>
Message-ID: <tip-8db732668a48e93d00d881517a08136e8fa71000@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1376058122-8248-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1376058122-8248-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock: Don'
 t inline _spin_unlock when using paravirt spinlocks
Git-Commit-ID: 8db732668a48e93d00d881517a08136e8fa71000
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 10 Aug 2013 09:13:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8db732668a48e93d00d881517a08136e8fa71000
Gitweb:     http://git.kernel.org/tip/8db732668a48e93d00d881517a08136e8fa71000
Author:     Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
AuthorDate: Fri, 9 Aug 2013 19:51:50 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Aug 2013 07:53:10 -0700

x86, ticketlock: Don't inline _spin_unlock when using paravirt spinlocks

The code size expands somewhat, and its better to just call
a function rather than inline it.

Thanks Jeremy for original version of ARCH_NOINLINE_SPIN_UNLOCK config patch,
which is simplified.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1376058122-8248-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..112e712 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -632,6 +632,7 @@ config PARAVIRT_DEBUG
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
 	depends on PARAVIRT && SMP
+	select UNINLINE_SPIN_UNLOCK
 	---help---
 	  Paravirtualized spinlocks allow a pvops backend to replace the
 	  spinlock implementation with something virtualization-friendly
