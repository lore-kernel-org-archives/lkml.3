Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3BYWUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:20:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759922Ab3BYWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Tejun Heo <tj@kernel.org>
Subject: [ 13/58] workqueue: un-GPL function delayed_work_timer_fn()
Date: Mon, 25 Feb 2013 14:19:09 -0800
Message-Id: <20130225221638.964918329@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit 1438ade5670b56d5386c220e1ad4b5a824a1e585 upstream.

commit d8e794dfd51c368ed3f686b7f4172830b60ae47b ("workqueue: set
delayed_work->timer function on initialization") exports function
delayed_work_timer_fn() only for GPL modules. This makes delayed-works
unusable for non-GPL modules, because initialization macro now requires
GPL symbol. For example schedule_delayed_work() available for non-GPL.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1350,7 +1350,7 @@ void delayed_work_timer_fn(unsigned long
 	/* should have been called from irqsafe timer with irq already off */
 	__queue_work(dwork->cpu, cwq->wq, &dwork->work);
 }
-EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
+EXPORT_SYMBOL(delayed_work_timer_fn);
 
 static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 				struct delayed_work *dwork, unsigned long delay)


