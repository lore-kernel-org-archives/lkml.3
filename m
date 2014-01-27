Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaA0SMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:12:17 -0500
Received: from mout.gmx.net ([212.227.17.21]:61795 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbaA0SLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:11:43 -0500
From: xypron.glpk@gmx.de
To: gxt@mprc.pku.edu.cn
Cc: akpm@linux-foundation.org, paul.gortmaker@windriver.com, vapier@gentoo.org,
        totglx@linutronix.de, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] __init setup_early_printk: missing initialization
Date: Mon, 27 Jan 2014 19:10:24 +0100
Message-Id: <1390846224-6995-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:tXkUS6FZmbwxZMW/lw7YBpH7a/B+l0UOpHy9wgDJacncfFSDGAn
 sS7SVcbTBUyanY5+9inrV3HK8ga3n9aTFLS6vA8fwF4MHRXgAG5gw81W2+cc7tdyPGHJkd9
 N8bNFbv1WXr3uABohj5fBiKUQb2/GIKVCZzbsBXQmA1IoM7eCjUXip+UflLEknPw/gbFObY
 DDRqyOQ4+vi1sfu1cbk2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

If is based on uninitialized value keep_early.
This leads to unpredictable result.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 arch/unicore32/kernel/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/unicore32/kernel/early_printk.c b/arch/unicore32/kernel/early_printk.c
index 9be0d5d..460a3b6 100644
--- a/arch/unicore32/kernel/early_printk.c
+++ b/arch/unicore32/kernel/early_printk.c
@@ -35,7 +35,7 @@ static struct console early_ocd_console = {
 
 static int __init setup_early_printk(char *buf)
 {
-	int keep_early;
+	int keep_early = 0;
 
 	if (!buf || early_console)
 		return 0;
-- 
1.7.10.4

