Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968027Ab3HJQPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:15:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab3HJQPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:15:30 -0400
Date: Sat, 10 Aug 2013 09:15:16 -0700
From: tip-bot for Raghavendra K T <tipbot@zytor.com>
Message-ID: <tip-3a3bb00d5c73f3ae7833f6534982b5b2f56ac9b4@git.kernel.org>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, raghavendra.kt@linux.vnet.ibm.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gleb@redhat.com, raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1376058122-8248-13-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1376058122-8248-13-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] kvm uapi:
  Add KICK_CPU and PV_UNHALT definition to uapi
Git-Commit-ID: 3a3bb00d5c73f3ae7833f6534982b5b2f56ac9b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 10 Aug 2013 09:15:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a3bb00d5c73f3ae7833f6534982b5b2f56ac9b4
Gitweb:     http://git.kernel.org/tip/3a3bb00d5c73f3ae7833f6534982b5b2f56ac9b4
Author:     Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
AuthorDate: Fri, 9 Aug 2013 19:52:00 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Aug 2013 07:54:12 -0700

kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi

These are needed by both guest and host.

Originally-from: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1376058122-8248-13-git-send-email-raghavendra.kt@linux.vnet.ibm.com
Acked-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/uapi/asm/kvm_para.h | 1 +
 include/uapi/linux/kvm_para.h        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 06fdbd9..94dc8ca 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -23,6 +23,7 @@
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
 #define KVM_FEATURE_PV_EOI		6
+#define KVM_FEATURE_PV_UNHALT		7
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index cea2c5c..2841f86 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_KICK_CPU			5
 
 /*
  * hypercalls use architecture specific
