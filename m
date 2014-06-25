Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaFYVyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:54:47 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:48643 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbaFYVyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:54:46 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org, davidlohr@hp.com,
        colin.king@canonical.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] tools: msgque improve error handling when not running as root
Date: Wed, 25 Jun 2014 15:54:42 -0600
Message-Id: <1403733282-12379-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test fails in the middle when it is not run as root while
accessing /proc/sys/kernel/msg_next_id. Changed it to check
for root at the beginning of the test and exit if not root.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/ipc/msgque.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index aa290c0..552f081 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -193,6 +193,11 @@ int main(int argc, char **argv)
 	int msg, pid, err;
 	struct msgque_data msgque;
 
+	if (getuid() != 0) {
+		printf("Please run the test as root - Exiting.\n");
+		exit(1);
+	}
+
 	msgque.key = ftok(argv[0], 822155650);
 	if (msgque.key == -1) {
 		printf("Can't make key\n");
-- 
1.9.1

