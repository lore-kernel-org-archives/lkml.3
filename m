Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaIYEzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:55:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40991 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaIYEzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:55:04 -0400
Date: Wed, 24 Sep 2014 21:54:40 -0700
From: "tip-bot for Bryan O'Donoghue" <tipbot@zytor.com>
Message-ID: <tip-02276a3a677d681f0cd227d7111c71fdbce23832@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pure.logic@nexus-software.ie, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pure.logic@nexus-software.ie, tglx@linutronix.de
In-Reply-To: <1411590363-8052-1-git-send-email-pure.logic@nexus-software.ie>
References: <1411590363-8052-1-git-send-email-pure.logic@nexus-software.ie>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/intel/quark:
  Add comment on TLB flush to setup_arch()
Git-Commit-ID: 02276a3a677d681f0cd227d7111c71fdbce23832
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

Commit-ID:  02276a3a677d681f0cd227d7111c71fdbce23832
Gitweb:     http://git.kernel.org/tip/02276a3a677d681f0cd227d7111c71fdbce23832
Author:     Bryan O'Donoghue <pure.logic@nexus-software.ie>
AuthorDate: Wed, 24 Sep 2014 21:26:03 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 25 Sep 2014 06:52:15 +0200

x86/intel/quark: Add comment on TLB flush to setup_arch()

Quark X1000 requires CR3 to be rewritten to flush TLB entries
irrespective of the PGE bits in CR4 or PTE.PGE.

Add a comment to setup_arch() to indicate that the code:

  load_cr3(swapper_pg_dir);
  __flush_tlb_all();

Will already have flushed the TLB @ the CR3 reload allowing us
to skip over a potential if/else for Quark.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Link: http://lkml.kernel.org/r/1411590363-8052-1-git-send-email-pure.logic@nexus-software.ie
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d..e7d7f6e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -878,6 +878,11 @@ void __init setup_arch(char **cmdline_p)
 			initial_page_table + KERNEL_PGD_BOUNDARY,
 			KERNEL_PGD_PTRS);
 
+	/*
+	 * Locate the page directory and flush the TLB.
+	 * On Quark X1000 rewriting CR3 flushes the TLB no if/else is required
+	 * to choose between __flush_tlb() and __flush_tlb_all()
+	 */
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #else
