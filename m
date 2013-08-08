Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966911Ab3HHXVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 19:21:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41110 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab3HHXV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 19:21:27 -0400
Date: Thu, 8 Aug 2013 16:21:09 -0700
From: tip-bot for Srivatsa Vaddagiri <tipbot@zytor.com>
Message-ID: <tip-20a89c88f7d2458e12f66d7850cf17deec7daa1c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, gleb@redhat.com, raghavendra.kt@linux.vnet.ibm.com,
        suzuki@in.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, gleb@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, suzuki@in.ibm.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130806114501.20643.5734.sendpatchset@codeblue.in.ibm.com>
References: <20130806114501.20643.5734.sendpatchset@codeblue.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] kvm guest :
  Add configuration support to enable debug information for KVM Guests
Git-Commit-ID: 20a89c88f7d2458e12f66d7850cf17deec7daa1c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 08 Aug 2013 16:21:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20a89c88f7d2458e12f66d7850cf17deec7daa1c
Gitweb:     http://git.kernel.org/tip/20a89c88f7d2458e12f66d7850cf17deec7daa1c
Author:     Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
AuthorDate: Tue, 6 Aug 2013 17:15:01 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 8 Aug 2013 16:07:30 -0700

kvm guest : Add configuration support to enable debug information for KVM Guests

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130806114501.20643.5734.sendpatchset@codeblue.in.ibm.com
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
