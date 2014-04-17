Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaDQTmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:42:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaDQTmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:42:18 -0400
Date: Thu, 17 Apr 2014 21:42:15 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] timer: prevent overflow in apply_slack
Message-ID: <20140417194215.GA10494@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent overflow in the computation of timer expiry time inside
apply_slack().

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Suggested-by: Deborah Townsend <dstownse@us.ibm.com>

diff --git a/kernel/timer.c b/kernel/timer.c
index 87bd529..4c36c91 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -838,7 +838,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1LL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 
-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

