Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaLGT17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:27:59 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3226 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530AbaLGT04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:26:56 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111932945"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 19/20] TTY: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:21:01 +0100
Message-Id: <1417980062-25151-20-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a misspelled function name by %s and then __func__.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/tty/rocket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 383c4c7..c8dd8dc 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -1390,7 +1390,7 @@ static void rp_unthrottle(struct tty_struct *tty)
 	       tty->ldisc.chars_in_buffer(tty));
 #endif
 
-	if (rocket_paranoia_check(info, "rp_throttle"))
+	if (rocket_paranoia_check(info, "rp_unthrottle"))
 		return;
 
 	if (I_IXOFF(tty))
@@ -1458,7 +1458,7 @@ static void rp_wait_until_sent(struct tty_struct *tty, int timeout)
 
 	orig_jiffies = jiffies;
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
-	printk(KERN_INFO "In RP_wait_until_sent(%d) (jiff=%lu)...\n", timeout,
+	printk(KERN_INFO "In %s(%d) (jiff=%lu)...\n", __func__, timeout,
 	       jiffies);
 	printk(KERN_INFO "cps=%d...\n", info->cps);
 #endif

