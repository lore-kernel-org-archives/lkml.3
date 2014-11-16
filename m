Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaKPSS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 13:18:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaKPSSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 13:18:55 -0500
Date: Sun, 16 Nov 2014 10:18:31 -0800
From: tip-bot for Dan Carpenter <tipbot@zytor.com>
Message-ID: <tip-acfcdccea94ed09cc2c20afbc5dca5bc6a6d69c7@git.kernel.org>
Cc: ak@linux.intel.com, hpa@zytor.com, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        rusty@rustcorp.com.au, jbeulich@suse.com
Reply-To: jbeulich@suse.com, rusty@rustcorp.com.au, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, ak@linux.intel.com
In-Reply-To: <20141115185718.GB6530@mwanda>
References: <20141115185718.GB6530@mwanda>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: lguest: interrupt[] array size has changed
Git-Commit-ID: acfcdccea94ed09cc2c20afbc5dca5bc6a6d69c7
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

Commit-ID:  acfcdccea94ed09cc2c20afbc5dca5bc6a6d69c7
Gitweb:     http://git.kernel.org/tip/acfcdccea94ed09cc2c20afbc5dca5bc6a6d69c7
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Sat, 15 Nov 2014 21:57:18 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 19:14:51 +0100

x86: lguest: interrupt[] array size has changed

Smatch complains that there is a buffer overflow here because we
recently changed interrupt[] from having "NR_VECTORS -
FIRST_EXTERNAL_VECTOR" elements to now have "FIRST_SYSTEM_VECTOR -
FIRST_EXTERNAL_VECTOR" elements.

Fixes: 8c66877ee65e ('x86: Avoid building unused IRQ entry stubs')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: lguest@lists.ozlabs.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/20141115185718.GB6530@mwanda
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/lguest/boot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index aae9413..c1c1544 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -841,7 +841,7 @@ static void __init lguest_init_IRQ(void)
 {
 	unsigned int i;
 
-	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+	for (i = FIRST_EXTERNAL_VECTOR; i < FIRST_SYSTEM_VECTOR; i++) {
 		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
 		__this_cpu_write(vector_irq[i], i - FIRST_EXTERNAL_VECTOR);
 		if (i != SYSCALL_VECTOR)
