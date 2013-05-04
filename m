Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763974Ab3EDBAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 21:00:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763795Ab3EDBAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 21:00:17 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=_B17V7oSJlIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=P1XUe1rnnr0A:10 a=pGLkceISAAAA:8 a=KTsQ3JU6CcB2jYZtCj4A:9 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130504010016.425969845@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 03 May 2013 20:59:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Dmitry Lysenko <dvl36.ripe.nick@gmail.com>
Subject: [PATCH RT 1/6] rcutiny: Fix typo of using swake_up() instead of swait_wake()
References: <20130504005955.061874443@goodmis.org>
Content-Disposition: inline; filename=0001-rcutiny-Fix-typo-of-using-swake_up-instead-of-swait_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Converting the rcutiny wake up queues to use the simple wait queues
there was a typo in one of the functions.

Reported-by: Dmitry Lysenko <dvl36.ripe.nick@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutiny_plugin.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f0a6606..6242ccd 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -883,7 +883,7 @@ static void rcu_preempt_process_callbacks(void)
 static void invoke_rcu_callbacks(void)
 {
 	have_rcu_kthread_work = 1;
-	swake_up(&rcu_kthread_wq);
+	swait_wake(&rcu_kthread_wq);
 }
 
 /*
-- 
1.7.10.4


