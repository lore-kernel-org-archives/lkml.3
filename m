Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3HFVoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:44:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3HFVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:44:13 -0400
Date: Tue, 6 Aug 2013 14:44:02 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-e0e745e45d3d3c22f60dc9b2c17bcfc0d9f2bc82@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-11-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-11-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage: Make syscall tables visible
Git-Commit-ID: e0e745e45d3d3c22f60dc9b2c17bcfc0d9f2bc82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:44:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0e745e45d3d3c22f60dc9b2c17bcfc0d9f2bc82
Gitweb:     http://git.kernel.org/tip/e0e745e45d3d3c22f60dc9b2c17bcfc0d9f2bc82
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:44 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:20:18 -0700

x86, asmlinkage: Make syscall tables visible

They are referenced from entry*.S.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-11-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
