Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaB0Qmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:42:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaB0Qmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:42:49 -0500
Date: Thu, 27 Feb 2014 08:42:38 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-jtdv7btppr4jgzxm3sxx1e74@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, cpufeature: If we disable CLFLUSH,
  we should disable CLFLUSHOPT
Git-Commit-ID: da4aaa7d860c63a1bfd3c73cf8309afe2840c5b9
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

Commit-ID:  da4aaa7d860c63a1bfd3c73cf8309afe2840c5b9
Gitweb:     http://git.kernel.org/tip/da4aaa7d860c63a1bfd3c73cf8309afe2840c5b9
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 27 Feb 2014 08:36:31 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Feb 2014 08:36:31 -0800

x86, cpufeature: If we disable CLFLUSH, we should disable CLFLUSHOPT

If we explicitly disable the use of CLFLUSH, we should disable the use
of CLFLUSHOPT as well.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-jtdv7btppr4jgzxm3sxx1e74@git.kernel.org
---
 arch/x86/kernel/cpu/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2c6ac6f..cca53d8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1026,6 +1026,7 @@ __setup("show_msr=", setup_show_msr);
 static __init int setup_noclflush(char *arg)
 {
 	setup_clear_cpu_cap(X86_FEATURE_CLFLUSH);
+	setup_clear_cpu_cap(X86_FEATURE_CLFLUSHOPT);
 	return 1;
 }
 __setup("noclflush", setup_noclflush);
