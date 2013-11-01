Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3KAOMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:12:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab3KAOME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:12:04 -0400
Date: Fri, 1 Nov 2013 10:11:49 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: prarit@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Allow NR_CPUS=1024
Message-ID: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current range for SMP configs is 2 - 512, or a full 4096 in the case of
MAXSMP.  There are machines that have 1024 CPUs in them today and configuring
a kernel for that means you are forced to set MAXSMP.  This adds additional
unnecessary overhead.  While that overhead might be considered tiny for large
machines, it isn't necessarily so if you are building a kernel that runs
across a wide variety of machines.  We increase the range to 1024 to help
with this.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839..d726b2d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -825,7 +825,7 @@ config MAXSMP
 config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
 	range 2 8 if SMP && X86_32 && !X86_BIGSMP
-	range 2 512 if SMP && !MAXSMP
+	range 2 1024 if SMP && !MAXSMP
 	default "1" if !SMP
 	default "4096" if MAXSMP
 	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
-- 
1.8.3.1

