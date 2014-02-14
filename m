Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaBND7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:59:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47865 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaBND7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:59:16 -0500
Date: Thu, 13 Feb 2014 19:59:06 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-00b7103078596a243c16239004e0dc9416910f13@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-8-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-8-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage:
  Make main_extable_sort_needed visible
Git-Commit-ID: 00b7103078596a243c16239004e0dc9416910f13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:59:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00b7103078596a243c16239004e0dc9416910f13
Gitweb:     http://git.kernel.org/tip/00b7103078596a243c16239004e0dc9416910f13
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:04 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:13:22 -0800

asmlinkage: Make main_extable_sort_needed visible

main_extable_sort_needed is used by the build system and needs
to be a normal ELF symbol. Make it visible so that LTO
does not remove or mangle it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-8-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/extable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 763faf0..d8a6446 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -36,7 +36,7 @@ extern struct exception_table_entry __start___ex_table[];
 extern struct exception_table_entry __stop___ex_table[];
 
 /* Cleared by build time tools if the table is already sorted. */
-u32 __initdata main_extable_sort_needed = 1;
+u32 __initdata __visible main_extable_sort_needed = 1;
 
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
