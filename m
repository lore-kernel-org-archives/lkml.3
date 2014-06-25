Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaFYTkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:40:15 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:36174 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaFYTkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:40:14 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org, davidlohr@hp.com,
        colin.king@canonical.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: msgque improve error handling when not running as root
Date: Wed, 25 Jun 2014 13:40:10 -0600
Message-Id: <1403725210-10245-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test fails in the middle when it is not run as root while
accessing /proc/sys/kernel/msg_next_id. Changed it to check
for root at the beginning of the test. Also added messages
to indicate start and test pass status.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/ipc/msgque.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index aa290c0..30c627a 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -193,6 +193,12 @@ int main(int argc, char **argv)
 	int msg, pid, err;
 	struct msgque_data msgque;
 
+	if (getuid() != 0) {
+		fprintf(stderr, "Please run the test as root - Exiting.\n");
+		exit(1);
+	}
+
+	printf("Starting ipc tests:\n");
 	msgque.key = ftok(argv[0], 822155650);
 	if (msgque.key == -1) {
 		printf("Can't make key\n");
@@ -235,6 +241,7 @@ int main(int argc, char **argv)
 		printf("Failed to test queue\n");
 		goto err_out;
 	}
+	printf("All ipc tests Passsed\n");
 	return 0;
 
 err_destroy:
-- 
1.9.1

