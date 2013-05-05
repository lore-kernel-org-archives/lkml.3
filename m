Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3EEJdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 05:33:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3EEJdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 05:33:10 -0400
Subject: [PATCH] idr: Print a stack dump after ida_remove warning
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Sun, 05 May 2013 11:32:03 +0200
Message-ID: <1367746323.4682.750.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We print a dump stack after idr_remove warning. This is useful to find
the faulty piece of code. Let's do the same for ida_remove, as it
would be equally useful there.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
---
 lib/idr.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.10-rc0.orig/lib/idr.c	2013-05-05 10:17:03.086198024 +0200
+++ linux-3.10-rc0/lib/idr.c	2013-05-05 10:41:11.939134735 +0200
@@ -1066,6 +1066,7 @@ void ida_remove(struct ida *ida, int id)
  err:
 	printk(KERN_WARNING
 	       "ida_remove called for id=%d which is not allocated.\n", id);
+	dump_stack();
 }
 EXPORT_SYMBOL(ida_remove);
 

-- 
Jean Delvare
Suse L3

