Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbbAFDBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:01:38 -0500
Received: from complete.lackof.org ([198.49.126.79]:39091 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbAFDBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:01:34 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 22:01:34 EST
From: dann frazier <dann.frazier@canonical.com>
To: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH] tools: testing: selftests: mq_perf_tests: Fix infinite loop on ARM
Date: Mon,  5 Jan 2015 19:54:40 -0700
Message-Id: <1420512880-392-1-git-send-email-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't use a char type to check for a negative return value since char
isn't guaranteed to be signed. Indeed, the char type tends to be unsigned on
ARM.

Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 tools/testing/selftests/mqueue/mq_perf_tests.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing/selftests/mqueue/mq_perf_tests.c
index 94dae65..8519e9e 100644
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c
+++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -536,10 +536,9 @@ int main(int argc, char *argv[])
 {
 	struct mq_attr attr;
 	char *option, *next_option;
-	int i, cpu;
+	int i, cpu, rc;
 	struct sigaction sa;
 	poptContext popt_context;
-	char rc;
 	void *retval;
 
 	main_thread = pthread_self();
-- 
2.1.4

