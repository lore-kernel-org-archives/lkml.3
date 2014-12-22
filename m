Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaLVSbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:31:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34202 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaLVSbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:31:14 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com
Subject: [PATCH] xen/time: Remove unnecessary BUG_ON(preemptible()) in xen_setup_timer()
Date: Mon, 22 Dec 2014 13:33:10 -0500
Message-Id: <1419273190-18821-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason for having it and, with commit 250a1ac685f1 ("x86,
smpboot: Remove pointless preempt_disable() in
native_smp_prepare_cpus()"), it prevents HVM guests from booting.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/time.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index f473d26..23019b4 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -458,8 +458,6 @@ void xen_setup_timer(int cpu)
 
 void xen_setup_cpu_clockevents(void)
 {
-	BUG_ON(preemptible());
-
 	clockevents_register_device(this_cpu_ptr(&xen_clock_events.evt));
 }
 
-- 
1.9.3

