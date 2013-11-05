Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3KEOiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:38:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab3KEOiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:38:23 -0500
Date: Tue, 5 Nov 2013 09:38:16 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: prarit@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: [PATCH 2/2] x86: Increase MAXSMP CPU count to 8192
Message-ID: <20131105143816.GK9944@hansolo.jdub.homelinux.org>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAXSMP option is intended to enable silly large numbers of CPUs for
testing purposes.  The current value of 4096 isn't very silly any longer
as there are actual machines that approach 6096 CPUs when taking HT into
account.  Increase the value to 8192 to account for this and short term
future increases.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f03e428..09f05cd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -828,7 +828,7 @@ config NR_CPUS
 	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
 	range 2 4096 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
 	default "1" if !SMP
-	default "4096" if MAXSMP
+	default "8192" if MAXSMP
 	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
 	default "8" if SMP
 	---help---
-- 
1.8.3.1
