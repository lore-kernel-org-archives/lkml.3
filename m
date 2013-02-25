Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837Ab3BYUyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:54:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33517 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3BYUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:54:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] docs: Fix incorrect comment about 64-bit code segment descriptors.
Date: Mon, 25 Feb 2013 15:54:10 -0500
Message-Id: <1361825650-14031-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1361825650-14031-1-git-send-email-konrad.wilk@oracle.com>
References: <1361825650-14031-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD64 Architecture Programmer's Manual Volume 2, on page
89 mentions: "If the processor is running in 64-bit mode (L=1),
the only valid setting of the D bit is 0." This matches
with what the code does.

CC: hpa@zytor.com
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/head_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index b7de3b2..6859e96 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -48,7 +48,7 @@ L3_START_KERNEL = pud_index(__START_KERNEL_map)
 	.globl startup_64
 startup_64:
 	/*
-	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 1,
+	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
 	 * and someone has loaded an identity mapped page table
 	 * for us.  These identity mapped page tables map all of the
 	 * kernel pages and possibly all of memory.
@@ -159,7 +159,7 @@ startup_64:
 	jmp 1f
 ENTRY(secondary_startup_64)
 	/*
-	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 1,
+	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
 	 * and someone has loaded a mapped page table.
 	 *
 	 * %rsi holds a physical pointer to real_mode_data.
-- 
1.8.0.2

