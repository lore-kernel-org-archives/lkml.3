Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaJQUqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:46:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48459 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJQUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:46:32 -0400
Date: Fri, 17 Oct 2014 13:46:16 -0700
From: tip-bot for Fabian Frederick <tipbot@zytor.com>
Message-ID: <tip-cbda45a2d4798912637b5b792c1c7a97c8d8b080@git.kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de, hpa@linux.intel.com,
        fabf@skynet.be, linux-kernel@vger.kernel.org
Reply-To: hpa@linux.intel.com, fabf@skynet.be, linux-kernel@vger.kernel.org,
        mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <1413576077-26969-1-git-send-email-fabf@skynet.be>
References: <1413576077-26969-1-git-send-email-fabf@skynet.be>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, cpuid: Use PTR_ERR_OR_ZERO
Git-Commit-ID: cbda45a2d4798912637b5b792c1c7a97c8d8b080
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

Commit-ID:  cbda45a2d4798912637b5b792c1c7a97c8d8b080
Gitweb:     http://git.kernel.org/tip/cbda45a2d4798912637b5b792c1c7a97c8d8b080
Author:     Fabian Frederick <fabf@skynet.be>
AuthorDate: Fri, 17 Oct 2014 22:01:17 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Oct 2014 13:40:51 -0700

x86, cpuid: Use PTR_ERR_OR_ZERO

Replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Link: http://lkml.kernel.org/r/1413576077-26969-1-git-send-email-fabf@skynet.be
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 3225ae6c..83741a7 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -143,7 +143,7 @@ static int cpuid_device_create(int cpu)
 
 	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
 			    "cpu%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void cpuid_device_destroy(int cpu)
