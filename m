Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaFYQFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:05:22 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:49492 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756886AbaFYQFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:05:21 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: fix mq_perf_tests compile warnings
Date: Wed, 25 Jun 2014 10:05:17 -0600
Message-Id: <1403712317-6638-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix numerous compile warnings in mq_perf_tests.c. All of these
are wrong format in printfs when printing nvsec.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/mqueue/mq_perf_tests.c | 40 ++++++++++++++------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing/selftests/mqueue/mq_perf_tests.c
index 2fadd4b..94dae65 100644
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c
+++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -296,9 +296,9 @@ static inline void open_queue(struct mq_attr *attr)
 	printf("\n\tQueue %s created:\n", queue_path);
 	printf("\t\tmq_flags:\t\t\t%s\n", result.mq_flags & O_NONBLOCK ?
 	       "O_NONBLOCK" : "(null)");
-	printf("\t\tmq_maxmsg:\t\t\t%d\n", result.mq_maxmsg);
-	printf("\t\tmq_msgsize:\t\t\t%d\n", result.mq_msgsize);
-	printf("\t\tmq_curmsgs:\t\t\t%d\n", result.mq_curmsgs);
+	printf("\t\tmq_maxmsg:\t\t\t%lu\n", result.mq_maxmsg);
+	printf("\t\tmq_msgsize:\t\t\t%lu\n", result.mq_msgsize);
+	printf("\t\tmq_curmsgs:\t\t\t%lu\n", result.mq_curmsgs);
 }
 
 void *fake_cont_thread(void *arg)
@@ -440,7 +440,7 @@ void *perf_test_thread(void *arg)
 		shutdown(2, "clock_getres()", __LINE__);
 
 	printf("\t\tMax priorities:\t\t\t%d\n", mq_prio_max);
-	printf("\t\tClock resolution:\t\t%d nsec%s\n", res.tv_nsec,
+	printf("\t\tClock resolution:\t\t%lu nsec%s\n", res.tv_nsec,
 	       res.tv_nsec > 1 ? "s" : "");
 
 
@@ -454,20 +454,20 @@ void *perf_test_thread(void *arg)
 	recv_total.tv_nsec = 0;
 	for (i = 0; i < TEST1_LOOPS; i++)
 		do_send_recv();
-	printf("\t\tSend msg:\t\t\t%d.%ds total time\n",
+	printf("\t\tSend msg:\t\t\t%ld.%lus total time\n",
 	       send_total.tv_sec, send_total.tv_nsec);
 	nsec = ((unsigned long long)send_total.tv_sec * 1000000000 +
 		 send_total.tv_nsec) / TEST1_LOOPS;
-	printf("\t\t\t\t\t\t%d nsec/msg\n", nsec);
-	printf("\t\tRecv msg:\t\t\t%d.%ds total time\n",
+	printf("\t\t\t\t\t\t%lld nsec/msg\n", nsec);
+	printf("\t\tRecv msg:\t\t\t%ld.%lus total time\n",
 	       recv_total.tv_sec, recv_total.tv_nsec);
 	nsec = ((unsigned long long)recv_total.tv_sec * 1000000000 +
 		recv_total.tv_nsec) / TEST1_LOOPS;
-	printf("\t\t\t\t\t\t%d nsec/msg\n", nsec);
+	printf("\t\t\t\t\t\t%lld nsec/msg\n", nsec);
 
 
 	for (cur_test = test2; cur_test->desc != NULL; cur_test++) {
-		printf(cur_test->desc);
+		printf("%s:\n", cur_test->desc);
 		printf("\t\t(%d iterations)\n", TEST2_LOOPS);
 		prio_out = 0;
 		send_total.tv_sec = 0;
@@ -493,16 +493,16 @@ void *perf_test_thread(void *arg)
 			cur_test->func(&prio_out);
 		}
 		printf("done.\n");
-		printf("\t\tSend msg:\t\t\t%d.%ds total time\n",
+		printf("\t\tSend msg:\t\t\t%ld.%lus total time\n",
 		       send_total.tv_sec, send_total.tv_nsec);
 		nsec = ((unsigned long long)send_total.tv_sec * 1000000000 +
 			 send_total.tv_nsec) / TEST2_LOOPS;
-		printf("\t\t\t\t\t\t%d nsec/msg\n", nsec);
-		printf("\t\tRecv msg:\t\t\t%d.%ds total time\n",
+		printf("\t\t\t\t\t\t%lld nsec/msg\n", nsec);
+		printf("\t\tRecv msg:\t\t\t%ld.%lus total time\n",
 		       recv_total.tv_sec, recv_total.tv_nsec);
 		nsec = ((unsigned long long)recv_total.tv_sec * 1000000000 +
 			recv_total.tv_nsec) / TEST2_LOOPS;
-		printf("\t\t\t\t\t\t%d nsec/msg\n", nsec);
+		printf("\t\t\t\t\t\t%lld nsec/msg\n", nsec);
 		printf("\t\tDraining queue...");
 		fflush(stdout);
 		clock_gettime(clock, &start);
@@ -653,8 +653,10 @@ int main(int argc, char *argv[])
 	/* Tell the user our initial state */
 	printf("\nInitial system state:\n");
 	printf("\tUsing queue path:\t\t\t%s\n", queue_path);
-	printf("\tRLIMIT_MSGQUEUE(soft):\t\t\t%d\n", saved_limits.rlim_cur);
-	printf("\tRLIMIT_MSGQUEUE(hard):\t\t\t%d\n", saved_limits.rlim_max);
+	printf("\tRLIMIT_MSGQUEUE(soft):\t\t\t%ld\n",
+		(long) saved_limits.rlim_cur);
+	printf("\tRLIMIT_MSGQUEUE(hard):\t\t\t%ld\n",
+		(long) saved_limits.rlim_max);
 	printf("\tMaximum Message Size:\t\t\t%d\n", saved_max_msgsize);
 	printf("\tMaximum Queue Size:\t\t\t%d\n", saved_max_msgs);
 	printf("\tNice value:\t\t\t\t%d\n", cur_nice);
@@ -667,10 +669,10 @@ int main(int argc, char *argv[])
 		printf("\tRLIMIT_MSGQUEUE(soft):\t\t\t(unlimited)\n");
 		printf("\tRLIMIT_MSGQUEUE(hard):\t\t\t(unlimited)\n");
 	} else {
-		printf("\tRLIMIT_MSGQUEUE(soft):\t\t\t%d\n",
-		       cur_limits.rlim_cur);
-		printf("\tRLIMIT_MSGQUEUE(hard):\t\t\t%d\n",
-		       cur_limits.rlim_max);
+		printf("\tRLIMIT_MSGQUEUE(soft):\t\t\t%ld\n",
+		       (long) cur_limits.rlim_cur);
+		printf("\tRLIMIT_MSGQUEUE(hard):\t\t\t%ld\n",
+		       (long) cur_limits.rlim_max);
 	}
 	printf("\tMaximum Message Size:\t\t\t%d\n", cur_max_msgsize);
 	printf("\tMaximum Queue Size:\t\t\t%d\n", cur_max_msgs);
-- 
1.9.1

