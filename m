Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab3BYWQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:16:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab3BYWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:16:31 -0500
Date: Mon, 25 Feb 2013 14:15:18 -0800
From: tip-bot for Konrad Rzeszutek Wilk <tipbot@zytor.com>
Message-ID: <tip-1256276c98dbcfb009ac8e0687df9a1e291fd149@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1361825650-14031-4-git-send-email-konrad.wilk@oracle.com>
References: <1361825650-14031-4-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, doc:
  Fix incorrect comment about 64-bit code segment descriptors
Git-Commit-ID: 1256276c98dbcfb009ac8e0687df9a1e291fd149
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 25 Feb 2013 14:15:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1256276c98dbcfb009ac8e0687df9a1e291fd149
Gitweb:     http://git.kernel.org/tip/1256276c98dbcfb009ac8e0687df9a1e291fd149
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Mon, 25 Feb 2013 15:54:10 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 25 Feb 2013 13:42:37 -0800

x86, doc: Fix incorrect comment about 64-bit code segment descriptors

The AMD64 Architecture Programmer's Manual Volume 2, on page
89 mentions: "If the processor is running in 64-bit mode (L=1),
the only valid setting of the D bit is 0." This matches
with what the code does.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1361825650-14031-4-git-send-email-konrad.wilk@oracle.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 980053c..37f5304 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -49,7 +49,7 @@ L3_START_KERNEL = pud_index(__START_KERNEL_map)
 startup_64:
 
 	/*
-	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 1,
+	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
 	 * and someone has loaded an identity mapped page table
 	 * for us.  These identity mapped page tables map all of the
 	 * kernel pages and possibly all of memory.
@@ -146,7 +146,7 @@ ident_complete:
 	jmp secondary_startup_64
 ENTRY(secondary_startup_64)
 	/*
-	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 1,
+	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
 	 * and someone has loaded a mapped page table.
 	 *
 	 * %esi holds a physical pointer to real_mode_data.
