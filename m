Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab3EOPea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:34:30 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:47767 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab3EOPe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:34:29 -0400
Message-ID: <5193AAFE.2010406@gmail.com>
Date: Wed, 15 May 2013 23:34:22 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, setup: Correct comment in reserve_crashkernel
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

One comment in reserve_crashkernel is out of date and incorrect.
So fix it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 56f7fcf..eba0d78 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -590,7 +590,12 @@ static void __init reserve_crashkernel(void)
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
 		/*
-		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
+		 *  For x86_64, when crashkernel=X,high is not passed, kexec
+		 *  wants bzImage is below CRASH_KERNEL_ADDR_LOW_MAX.
+		 *  For x86_32, crashkernel=X,high is not supported by defining
+		 *  CRASH_KERNEL_ADDR_HIGH_MAX and CRASH_KERNEL_ADDR_LOW_MAX
+		 *  with the same limit and kexec always wants bzImage is below
+		 *  this limit due to mapping restrictions.
 		 */
 		crash_base = memblock_find_in_range(alignment,
 					high ? CRASH_KERNEL_ADDR_HIGH_MAX :
-- 
1.7.1
