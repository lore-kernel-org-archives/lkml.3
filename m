Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaCWPMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:12:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:58038 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbaCWPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:20 -0400
Message-Id: <20140323150752.960739079@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>, Michael Reed <mdr@sgi.com>,
        scsi <linux-scsi@vger.kernel.org>
Subject: [patch 04/16] scsi: qla1280: Add missing destroy_timer_on_stack()
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline;
 filename=scsi-qla1280-add-missing-destroy-timer-on-stack.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we leak a tracking object when DEBUG_OBJECTS is enabled.

This code should use wait_for_completion_timeout() instead, but that's
a different issue.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Reed <mdr@sgi.com>
Cc: scsi <linux-scsi@vger.kernel.org>
---
 drivers/scsi/qla1280.c |    1 +
 1 file changed, 1 insertion(+)

Index: tip/drivers/scsi/qla1280.c
===================================================================
--- tip.orig/drivers/scsi/qla1280.c
+++ tip/drivers/scsi/qla1280.c
@@ -2514,6 +2514,7 @@ qla1280_mailbox_command(struct scsi_qla_
 
 	wait_for_completion(&wait);
 	del_timer_sync(&timer);
+	destroy_timer_on_stack(&timer);
 
 	spin_lock_irq(ha->host->host_lock);
 


