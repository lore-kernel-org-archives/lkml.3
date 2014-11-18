Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaKRAF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:05:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKRAFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:05:21 -0500
Date: Mon, 17 Nov 2014 16:05:07 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-62e7759b1bdaf9b753c3724a56fcbe3235ebd5f3@git.kernel.org>
Cc: tglx@linutronix.de, qiaowei.ren@intel.com, mingo@kernel.org, dave@sr71.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com
Reply-To: tglx@linutronix.de, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, mingo@kernel.org, dave@sr71.net
In-Reply-To: <20141114151817.031762AC@viggo.jf.intel.com>
References: <20141114151817.031762AC@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86, mpx: Rename cfg_reg_u and status_reg
Git-Commit-ID: 62e7759b1bdaf9b753c3724a56fcbe3235ebd5f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62e7759b1bdaf9b753c3724a56fcbe3235ebd5f3
Gitweb:     http://git.kernel.org/tip/62e7759b1bdaf9b753c3724a56fcbe3235ebd5f3
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Fri, 14 Nov 2014 07:18:17 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 00:58:53 +0100

x86, mpx: Rename cfg_reg_u and status_reg

According to Intel SDM extension, MPX configuration and status registers
should be BNDCFGU and BNDSTATUS. This patch renames cfg_reg_u and
status_reg to bndcfgu and bndstatus.

[ tglx: Renamed 'struct bndscr_struct' to 'struct bndscr' ]

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-mm@kvack.org
Cc: linux-mips@linux-mips.org
Cc: Dave Hansen <dave@sr71.net>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
Link: http://lkml.kernel.org/r/20141114151817.031762AC@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/processor.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0f2263a..6571aaa 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -379,9 +379,9 @@ struct bndreg {
 	u64 upper_bound;
 } __packed;
 
-struct bndcsr_struct {
-	u64 cfg_reg_u;
-	u64 status_reg;
+struct bndcsr {
+	u64 bndcfgu;
+	u64 bndstatus;
 } __packed;
 
 struct xsave_hdr_struct {
@@ -396,7 +396,7 @@ struct xsave_struct {
 	struct ymmh_struct ymmh;
 	struct lwp_struct lwp;
 	struct bndreg bndreg[4];
-	struct bndcsr_struct bndcsr;
+	struct bndcsr bndcsr;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
