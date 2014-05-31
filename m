Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935126AbaEaDgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:36:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50722 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbaEaDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:36:40 -0400
Date: Fri, 30 May 2014 20:36:27 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-c9e5a5a7034146493386d985ff432aed8059929a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-7-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-7-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsave:
  Make it clear that the XSAVE macros use (%edi)/(%rdi)
Git-Commit-ID: c9e5a5a7034146493386d985ff432aed8059929a
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

Commit-ID:  c9e5a5a7034146493386d985ff432aed8059929a
Gitweb:     http://git.kernel.org/tip/c9e5a5a7034146493386d985ff432aed8059929a
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 30 May 2014 08:19:21 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 May 2014 08:19:21 -0700

x86/xsave: Make it clear that the XSAVE macros use (%edi)/(%rdi)

The XSAVE instruction family takes a memory argment.  The macros use
(%edi)/(%rdi) as that memory argument - make that clear to the reader.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-7-git-send-email-fenghua.yu@intel.com
---
 arch/x86/include/asm/xsave.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 1ba577c..bbebd6e 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -52,6 +52,7 @@ extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
 
+/* These macros all use (%edi)/(%rdi) as the single memory argument. */
 #define XSAVE		".byte " REX_PREFIX "0x0f,0xae,0x27"
 #define XSAVEOPT	".byte " REX_PREFIX "0x0f,0xae,0x37"
 #define XSAVES		".byte " REX_PREFIX "0x0f,0xc7,0x2f"
