Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab3F1QJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab3F1QJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:09:58 -0400
Date: Fri, 28 Jun 2013 09:09:41 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-4f4319a02a6108be3e65b9d44d1b7f5e8f520535@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1372369996-20556-1-git-send-email-bp@alien8.de>
References: <1372369996-20556-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/ioremap: Correct function name output
Git-Commit-ID: 4f4319a02a6108be3e65b9d44d1b7f5e8f520535
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 09:09:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f4319a02a6108be3e65b9d44d1b7f5e8f520535
Gitweb:     http://git.kernel.org/tip/4f4319a02a6108be3e65b9d44d1b7f5e8f520535
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Thu, 27 Jun 2013 23:53:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 28 Jun 2013 11:11:58 +0200

x86/ioremap: Correct function name output

Infact, let the compiler enter the function name so that there
are no discrepancies.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1372369996-20556-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/ioremap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 9a1e658..0215e2c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -501,15 +501,15 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	}
 
 	if (slot < 0) {
-		printk(KERN_INFO "early_iomap(%08llx, %08lx) not found slot\n",
-			 (u64)phys_addr, size);
+		printk(KERN_INFO "%s(%08llx, %08lx) not found slot\n",
+		       __func__, (u64)phys_addr, size);
 		WARN_ON(1);
 		return NULL;
 	}
 
 	if (early_ioremap_debug) {
-		printk(KERN_INFO "early_ioremap(%08llx, %08lx) [%d] => ",
-		       (u64)phys_addr, size, slot);
+		printk(KERN_INFO "%s(%08llx, %08lx) [%d] => ",
+		       __func__, (u64)phys_addr, size, slot);
 		dump_stack();
 	}
 
