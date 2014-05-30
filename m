Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbaE3PNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:13:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44172 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738AbaE3PM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:12:58 -0400
Date: Fri, 30 May 2014 08:12:47 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-21e726c4a3625a1038e97795b7aad97109ba7e19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-12-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-12-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves: Clear reserved bits in xsave header
Git-Commit-ID: 21e726c4a3625a1038e97795b7aad97109ba7e19
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

Commit-ID:  21e726c4a3625a1038e97795b7aad97109ba7e19
Gitweb:     http://git.kernel.org/tip/21e726c4a3625a1038e97795b7aad97109ba7e19
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:39 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:33:00 -0700

x86/xsaves: Clear reserved bits in xsave header

The reserved bits (128~511) in the xsave header must be zero according to
X86 SDM. Clear the bits in this patch.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-12-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/i387.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index d5dd808..a9a4229 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -375,7 +375,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	/*
 	 * These bits must be zero.
 	 */
-	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+	memset(xsave_hdr->reserved, 0, 48);
 
 	return ret;
 }
