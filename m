Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaCWPNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:13:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:57984 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaCWPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:17 -0400
Message-Id: <20140323150752.843705144@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ursula Braun <ursula.braun@de.ibm.com>,
        s390 <linux-s390@vger.kernel.org>
Subject: [patch 03/16] s390: net: lcs: Add missing destroy_timer_on_stack()
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline;
 filename=s390-net-lcs-add-missing-destroy-timer-on-stack.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we leak a tracking object when DEBUG_OBJECTS is enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ursula Braun <ursula.braun@de.ibm.com>
Cc: s390 <linux-s390@vger.kernel.org>
---
 drivers/s390/net/lcs.c |    1 +
 1 file changed, 1 insertion(+)

Index: tip/drivers/s390/net/lcs.c
===================================================================
--- tip.orig/drivers/s390/net/lcs.c
+++ tip/drivers/s390/net/lcs.c
@@ -899,6 +899,7 @@ lcs_send_lancmd(struct lcs_card *card, s
 	add_timer(&timer);
 	wait_event(reply->wait_q, reply->received);
 	del_timer_sync(&timer);
+	destroy_timer_on_stack(&timer);
 	LCS_DBF_TEXT_(4, trace, "rc:%d",reply->rc);
 	rc = reply->rc;
 	lcs_put_reply(reply);


