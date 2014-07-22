Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbaGVVrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:47:45 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:62219 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbaGVVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:47:43 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: tglx@linutronix.de
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] x86: Remove Fix me in main.c and add include statement for kvm_para.h
Date: Tue, 22 Jul 2014 17:47:38 -0400
Message-Id: <1406065658-3866-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a fix me by including linux/types.h in kvm_para.h
as stated by the  fix me in main.c and also removes the comment from
main.c too.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c | 2 +-
 include/linux/kvm_para.h        | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index f961de9..7ba314b 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -33,7 +33,7 @@
 
 #define DEBUG
 
-#include <linux/types.h> /* FIXME: kvm_para.h needs this */
+#include <linux/types.h>
 
 #include <linux/stop_machine.h>
 #include <linux/kvm_para.h>
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 00a97bb..21d1be2 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -2,8 +2,7 @@
 #define __LINUX_KVM_PARA_H
 
 #include <uapi/linux/kvm_para.h>
-
-
+#include <linux/types.h>
 static inline int kvm_para_has_feature(unsigned int feature)
 {
 	if (kvm_arch_para_features() & (1UL << feature))
-- 
1.9.1

