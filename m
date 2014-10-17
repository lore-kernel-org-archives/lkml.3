Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaJQUrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:47:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaJQUrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:47:11 -0400
Date: Fri, 17 Oct 2014 13:46:59 -0700
From: tip-bot for Fabian Frederick <tipbot@zytor.com>
Message-ID: <tip-cba0fdbcff8b54c206c8e18898a55456959ed51a@git.kernel.org>
Cc: hpa@linux.intel.com, hpa@zytor.com, fabf@skynet.be, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: hpa@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, fabf@skynet.be
In-Reply-To: <1413576099-27059-1-git-send-email-fabf@skynet.be>
References: <1413576099-27059-1-git-send-email-fabf@skynet.be>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, msr: Use PTR_ERR_OR_ZERO
Git-Commit-ID: cba0fdbcff8b54c206c8e18898a55456959ed51a
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

Commit-ID:  cba0fdbcff8b54c206c8e18898a55456959ed51a
Gitweb:     http://git.kernel.org/tip/cba0fdbcff8b54c206c8e18898a55456959ed51a
Author:     Fabian Frederick <fabf@skynet.be>
AuthorDate: Fri, 17 Oct 2014 22:01:38 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Oct 2014 13:40:53 -0700

x86, msr: Use PTR_ERR_OR_ZERO

Replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Link: http://lkml.kernel.org/r/1413576099-27059-1-git-send-email-fabf@skynet.be
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index c9603ac..6e4f77f 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -206,7 +206,7 @@ static int msr_device_create(int cpu)
 
 	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu), NULL,
 			    "msr%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void msr_device_destroy(int cpu)
