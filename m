Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaLEKCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:02:30 -0500
Received: from vsp-unauthed01.binero.net ([195.74.38.225]:28364 "EHLO
	bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752728AbaLEKC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:02:28 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2014 05:02:28 EST
X-Halon-ID: f658d93d-7c64-11e4-8a31-005056917f90
Authorized-sender: andreas@gaisler.com
From: Andreas Larsson <andreas@gaisler.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH] sparc32,leon: Align ccall_info to prevent unaligned traps on crosscall
Date: Fri,  5 Dec 2014 10:55:28 +0100
Message-Id: <1417773328-10396-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is being filled in using std in leon_cross_call.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 arch/sparc/kernel/leon_smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index ea2bad3..71e16f2 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -368,7 +368,7 @@ static struct smp_funcall {
 	unsigned long arg5;
 	unsigned long processors_in[NR_CPUS];	/* Set when ipi entered. */
 	unsigned long processors_out[NR_CPUS];	/* Set when ipi exited. */
-} ccall_info;
+} ccall_info __attribute__((aligned(8)));
 
 static DEFINE_SPINLOCK(cross_call_lock);
 
-- 
1.7.10.4

