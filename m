Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaI2NPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:15:06 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:34969 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbaI2NPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:15:01 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, dave@stgolabs.net,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 2/4] locktorture: Fix __acquire annotation for spinlock irq
Date: Mon, 29 Sep 2014 06:14:24 -0700
Message-Id: <1411996466-11488-3-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
References: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its quite easy to get mixed up with the names -- 'torture_spinlock_irq'
is not actually a valid spinlock name.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/locktorture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 0762b25..9e9cd11 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -205,7 +205,7 @@ static struct lock_torture_ops spin_lock_ops = {
 };
 
 static int torture_spin_lock_write_lock_irq(void)
-__acquires(torture_spinlock_irq)
+__acquires(torture_spinlock)
 {
 	unsigned long flags;
 
-- 
1.8.4.5

