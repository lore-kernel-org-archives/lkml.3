Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbaGPPw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:52:59 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35364 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965166AbaGPPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:52:55 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org,
        qemu-devel@nongnu.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH qemu] i386,linux-headers: Add support for kvm_get_rng_seed
Date: Wed, 16 Jul 2014 08:52:50 -0700
Message-Id: <3b8cd70724017ab9604f1c34644df75549e61846.1405525932.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates x86's kvm_para.h for the feature bit definition and
target-i386/cpu.c for the feature name and default.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 linux-headers/asm-x86/kvm_para.h | 2 ++
 target-i386/cpu.c                | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/linux-headers/asm-x86/kvm_para.h b/linux-headers/asm-x86/kvm_para.h
index e41c5c1..a9b27ce 100644
--- a/linux-headers/asm-x86/kvm_para.h
+++ b/linux-headers/asm-x86/kvm_para.h
@@ -24,6 +24,7 @@
 #define KVM_FEATURE_STEAL_TIME		5
 #define KVM_FEATURE_PV_EOI		6
 #define KVM_FEATURE_PV_UNHALT		7
+#define KVM_FEATURE_GET_RNG_SEED	8
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -40,6 +41,7 @@
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_GET_RNG_SEED 0x4b564d05
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/target-i386/cpu.c b/target-i386/cpu.c
index 8fd1497..4ea7e6c 100644
--- a/target-i386/cpu.c
+++ b/target-i386/cpu.c
@@ -236,7 +236,7 @@ static const char *ext4_feature_name[] = {
 static const char *kvm_feature_name[] = {
     "kvmclock", "kvm_nopiodelay", "kvm_mmu", "kvmclock",
     "kvm_asyncpf", "kvm_steal_time", "kvm_pv_eoi", "kvm_pv_unhalt",
-    NULL, NULL, NULL, NULL,
+    "kvm_get_rng_seed", NULL, NULL, NULL,
     NULL, NULL, NULL, NULL,
     NULL, NULL, NULL, NULL,
     NULL, NULL, NULL, NULL,
@@ -368,7 +368,8 @@ static uint32_t kvm_default_features[FEATURE_WORDS] = {
         (1 << KVM_FEATURE_ASYNC_PF) |
         (1 << KVM_FEATURE_STEAL_TIME) |
         (1 << KVM_FEATURE_PV_EOI) |
-        (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT),
+        (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+        (1 << KVM_FEATURE_GET_RNG_SEED),
     [FEAT_1_ECX] = CPUID_EXT_X2APIC,
 };
 
-- 
1.9.3

