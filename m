Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968187Ab3HJQPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:15:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948Ab3HJQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:15:44 -0400
Date: Sat, 10 Aug 2013 09:15:26 -0700
From: tip-bot for Srivatsa Vaddagiri <tipbot@zytor.com>
Message-ID: <tip-1e20eb8557cdabf76473b09572be8aa8a2bb9bc0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, gleb@redhat.com, raghavendra.kt@linux.vnet.ibm.com,
        suzuki@in.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, gleb@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, suzuki@in.ibm.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1376058122-8248-14-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1376058122-8248-14-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] kvm guest:
  Add configuration support to enable debug information for KVM Guests
Git-Commit-ID: 1e20eb8557cdabf76473b09572be8aa8a2bb9bc0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 10 Aug 2013 09:15:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e20eb8557cdabf76473b09572be8aa8a2bb9bc0
Gitweb:     http://git.kernel.org/tip/1e20eb8557cdabf76473b09572be8aa8a2bb9bc0
Author:     Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
AuthorDate: Fri, 9 Aug 2013 19:52:01 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Aug 2013 07:54:18 -0700

kvm guest: Add configuration support to enable debug information for KVM Guests

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1376058122-8248-14-git-send-email-raghavendra.kt@linux.vnet.ibm.com
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 112e712..b1fb846 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -657,6 +657,15 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_DEBUG_FS
+	bool "Enable debug information for KVM Guests in debugfs"
+	depends on KVM_GUEST && DEBUG_FS
+	default n
+	---help---
+	  This option enables collection of various statistics for KVM guest.
+	  Statistics are displayed in debugfs filesystem. Enabling this option
+	  may incur significant overhead.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT_TIME_ACCOUNTING
