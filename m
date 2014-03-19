Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbaCSJpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:45:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904AbaCSJpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:45:19 -0400
Date: Wed, 19 Mar 2014 10:45:17 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: printk: One small fixup for patch 5/8
Message-ID: <20140319094517.GC26358@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  this is a small fixup for the patch 5/8 (printk: Hand over printing to
console if printing too long) in my printk series. It fixes a bogus warning
on non-preemptible kernels. Please just fold it into that patch (I can
resend the patch or the series but I don't think that's necessary for such
a small fixup).

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 0910e1894224..cb7e06850eb5 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2022,7 +2022,7 @@ EXPORT_SYMBOL(console_trylock);
  */
 static int console_lock_try_spin(void)
 {
-	WARN_ON_ONCE(!in_atomic());
+	WARN_ON_ONCE(preemptible());
 	/* Someone already spinning? Don't waste cpu time... */
 	if (test_and_set_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
 		return 0;
