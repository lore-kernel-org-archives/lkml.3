Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaGPVNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:13:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:59785 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaGPVEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:48 -0400
Message-Id: <20140716205055.494841616@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: [patch V2 39/64] fs: lockd: Use ktime_get_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=fs-lockd-remove-silly-timestamp-dance.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ever recurring:
        ts = ktime_get_ts();
        ns = timespec_to_ns(&ts);
with
        ns = ktime_get_ns();

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
---
 fs/lockd/mon.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: tip/fs/lockd/mon.c
===================================================================
--- tip.orig/fs/lockd/mon.c
+++ tip/fs/lockd/mon.c
@@ -306,11 +306,9 @@ static struct nsm_handle *nsm_lookup_pri
 static void nsm_init_private(struct nsm_handle *nsm)
 {
 	u64 *p = (u64 *)&nsm->sm_priv.data;
-	struct timespec ts;
 	s64 ns;
 
-	ktime_get_ts(&ts);
-	ns = timespec_to_ns(&ts);
+	ns = ktime_get_ns();
 	put_unaligned(ns, p);
 	put_unaligned((unsigned long)nsm, p + 1);
 }


