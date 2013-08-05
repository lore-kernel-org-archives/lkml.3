Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3HEWGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:06:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:52091 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab3HEWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="376599279"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/16] x86, asmlinkage: Make syscall tables visible
Date: Mon,  5 Aug 2013 15:02:44 -0700
Message-Id: <1375740170-7446-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

They are referenced from entry*.S.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/syscall_32.c | 2 +-
 arch/x86/kernel/syscall_64.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/syscall_32.c b/arch/x86/kernel/syscall_32.c
index 147fcd4..e9bcd57 100644
--- a/arch/x86/kernel/syscall_32.c
+++ b/arch/x86/kernel/syscall_32.c
@@ -15,7 +15,7 @@ typedef asmlinkage void (*sys_call_ptr_t)(void);
 
 extern asmlinkage void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
+__visible const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index ec008f5..4ac730b 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -22,7 +22,7 @@
 
 extern void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
+asmlinkage const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
-- 
1.8.3.1

