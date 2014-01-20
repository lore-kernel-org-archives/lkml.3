Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaATTkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:40:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50407 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaATTkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:40:15 -0500
Date: Mon, 20 Jan 2014 11:39:27 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-741e3902cd89a7fbc04ae53f29a7ca0da452aa8e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, qiaowei.ren@intel.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86/intel/mpx: Remove unused LWP structure
Git-Commit-ID: 741e3902cd89a7fbc04ae53f29a7ca0da452aa8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 20 Jan 2014 11:39:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  741e3902cd89a7fbc04ae53f29a7ca0da452aa8e
Gitweb:     http://git.kernel.org/tip/741e3902cd89a7fbc04ae53f29a7ca0da452aa8e
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 20 Jan 2014 19:51:05 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 20 Jan 2014 19:57:39 +0100

x86/intel/mpx: Remove unused LWP structure

We don't support LWP yet, don't give the impression that we do:
represent the LWP state as opaque 128 bytes, the way Linux sees it
currently.

Cc: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-ecarmjtfKpanpAapfck6dj6g@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/processor.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b7845a1..865c399 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -370,15 +370,9 @@ struct ymmh_struct {
 	u32 ymmh_space[64];
 };
 
+/* We don't support LWP yet: */
 struct lwp_struct {
-	u64 lwpcb_addr;
-	u32 flags;
-	u32 buf_head_offset;
-	u64 buf_base;
-	u32 buf_size;
-	u32 filters;
-	u64 saved_event_record[4];
-	u32 event_counter[16];
+	u8 reserved[128];
 };
 
 struct bndregs_struct {
