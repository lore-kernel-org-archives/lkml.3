Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaJQUr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:47:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJQUrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:47:24 -0400
Date: Fri, 17 Oct 2014 13:47:13 -0700
From: tip-bot for Fabian Frederick <tipbot@zytor.com>
Message-ID: <tip-951a18c6fee5d2f6f5d7b5118776bf787bf9c351@git.kernel.org>
Cc: fabf@skynet.be, hpa@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org
Reply-To: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, hpa@linux.intel.com, fabf@skynet.be
In-Reply-To: <1413576110-27103-1-git-send-email-fabf@skynet.be>
References: <1413576110-27103-1-git-send-email-fabf@skynet.be>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, msr: Convert printk to pr_foo()
Git-Commit-ID: 951a18c6fee5d2f6f5d7b5118776bf787bf9c351
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

Commit-ID:  951a18c6fee5d2f6f5d7b5118776bf787bf9c351
Gitweb:     http://git.kernel.org/tip/951a18c6fee5d2f6f5d7b5118776bf787bf9c351
Author:     Fabian Frederick <fabf@skynet.be>
AuthorDate: Fri, 17 Oct 2014 22:01:50 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Oct 2014 13:40:54 -0700

x86, msr: Convert printk to pr_foo()

Also define pr_fmt.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Link: http://lkml.kernel.org/r/1413576110-27103-1-git-send-email-fabf@skynet.be
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/msr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 6e4f77f..826c8b0 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -22,6 +22,8 @@
  * an SMP box will direct the access to CPU %d.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 
 #include <linux/types.h>
@@ -248,8 +250,7 @@ static int __init msr_init(void)
 	i = 0;
 
 	if (__register_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr", &msr_fops)) {
-		printk(KERN_ERR "msr: unable to get major %d for msr\n",
-		       MSR_MAJOR);
+		pr_err("unable to get major %d for msr\n", MSR_MAJOR);
 		err = -EBUSY;
 		goto out;
 	}
