Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3LWGj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:39:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3LWGj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:39:28 -0500
Message-ID: <1387780764.6606.7.camel@marge.simpson.net>
Subject: [patch] sched: Fix up /proc/sched_debug to print only runnable
 tasks again
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Dec 2013 07:39:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:C9id5+QGw3o6hU5nWqRLcg1eLilMmEDgrwp06btJFuZ
 bzv3TEPFQ9BfJR94bH201/gAdXzOHOnTJlCdbUmJEdKyBlRuRv
 6qgj1st0EhXZhOYEqYjO1KCqicDHM0Oomk5HmzYIZLIb0FaOKJ
 9H1QPZzEIC4xof9Jk0Zi0bZQ1x4xcjvIihofaOwLvgG8uciDaL
 0ksLNX4MyteOnNjtvHsUxhUV6VELNbVCXE/aDJwQKcnSVxX5HJ
 KXUQufCEjCete7bKpUUa1kzq61ixd/kU8INjFdTOd6tg0ozl3Z
 fmqECM7jG9C21zaSrsx/syOdLAahtP237dhtYXUFx1KoKb63kK
 rY46xlIScDIB/oZ12Na2TaQbzsN/eHVYaUnB/ww3PLTEmvciWw
 6xvq7k82EK+1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This hunk of b32e86b430 looks like a booboo.


Commit b32e86b430 dropped p->on_rq check, leading to printing tasks which
used to live on runqueues, which is very noisy (and annoying as heck).

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 kernel/sched/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -163,7 +163,7 @@ static void print_rq(struct seq_file *m,
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, p) {
-		if (task_cpu(p) != rq_cpu)
+		if (!p->on_rq || task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);


