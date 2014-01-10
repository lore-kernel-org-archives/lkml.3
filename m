Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaAJOuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:50:23 -0500
Received: from mail1.windriver.com ([147.11.146.13]:54444 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaAJOuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:50:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <xen-devel@lists.xenproject.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH-next] xen: delete new instances of __cpuinit usage
Date: Fri, 10 Jan 2014 09:50:08 -0500
Message-ID: <1389365408-24034-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1fe565517b57676884349dccfd6ce853ec338636 ("xen/events: use
the FIFO-based ABI if available") added new instances of __cpuinit
macro usage.

We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what
we want to see at this point in time, as it will break once
the stubs are gone.

Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Patch based on today's linux-next tree, so if xen/tip.git#linux-next
 gets rebased, then the above commit ID will be invalidated; if it
 _does_ get rebased, then feel free to squash this fix into the orig.]

diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 5b2c039f16c5..1de2a191b395 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -359,7 +359,7 @@ static const struct evtchn_ops evtchn_ops_fifo = {
 	.resume            = evtchn_fifo_resume,
 };
 
-static int __cpuinit evtchn_fifo_init_control_block(unsigned cpu)
+static int evtchn_fifo_init_control_block(unsigned cpu)
 {
 	struct page *control_block = NULL;
 	struct evtchn_init_control init_control;
@@ -386,7 +386,7 @@ static int __cpuinit evtchn_fifo_init_control_block(unsigned cpu)
 	return ret;
 }
 
-static int __cpuinit evtchn_fifo_cpu_notification(struct notifier_block *self,
+static int evtchn_fifo_cpu_notification(struct notifier_block *self,
 						  unsigned long action,
 						  void *hcpu)
 {
@@ -404,7 +404,7 @@ static int __cpuinit evtchn_fifo_cpu_notification(struct notifier_block *self,
 	return ret < 0 ? NOTIFY_BAD : NOTIFY_OK;
 }
 
-static struct notifier_block evtchn_fifo_cpu_notifier __cpuinitdata = {
+static struct notifier_block evtchn_fifo_cpu_notifier = {
 	.notifier_call	= evtchn_fifo_cpu_notification,
 };
 
-- 
1.8.5.2

