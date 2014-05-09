Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbaEIQbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:31:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbaEIQbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:31:47 -0400
Date: Fri, 9 May 2014 09:31:17 -0700
From: tip-bot for Andres Freund <tipbot@zytor.com>
Message-ID: <tip-722a0d22d028bd74061cf582de1764884e73674f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andres@anarazel.de, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andres@anarazel.de, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1399598957-7011-2-git-send-email-andres@anarazel.de>
References: <1399598957-7011-2-git-send-email-andres@anarazel.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix typo preventing msr_set/
 clear_bit from having an effect
Git-Commit-ID: 722a0d22d028bd74061cf582de1764884e73674f
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

Commit-ID:  722a0d22d028bd74061cf582de1764884e73674f
Gitweb:     http://git.kernel.org/tip/722a0d22d028bd74061cf582de1764884e73674f
Author:     Andres Freund <andres@anarazel.de>
AuthorDate: Fri, 9 May 2014 03:29:16 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 9 May 2014 08:42:32 -0700

x86: Fix typo preventing msr_set/clear_bit from having an effect

Due to a typo the msr accessor function introduced in
22085a66c2fab6cf9b9393c056a3600a6b4735de didn't have any lasting
effects because they accidentally wrote the old value back.

After c0a639ad0bc6b178b46996bd1f821a04643e2bde this at the very least
this causes cpuid limits not to be lifted on some cpus leading to
missing capabilities for those.

Signed-off-by: Andres Freund <andres@anarazel.de>
Link: http://lkml.kernel.org/r/1399598957-7011-2-git-send-email-andres@anarazel.de
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/lib/msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index db9db44..4362373 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -76,7 +76,7 @@ static inline int __flip_bit(u32 msr, u8 bit, bool set)
 	if (m1.q == m.q)
 		return 0;
 
-	err = msr_write(msr, &m);
+	err = msr_write(msr, &m1);
 	if (err)
 		return err;
 
