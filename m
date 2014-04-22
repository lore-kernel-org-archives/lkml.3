Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaDVSeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:34:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaDVSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:34:31 -0400
Date: Tue, 22 Apr 2014 11:34:19 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-f5b1f4e483d55a88ed120e2c62b45ba5b939fa72@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, dzickus@redhat.com,
        jolsa@redhat.com
In-Reply-To: <1396896924-129847-3-git-send-email-dzickus@redhat.com>
References: <1396896924-129847-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use cpu/possible instead of cpu/
 kernel_max
Git-Commit-ID: f5b1f4e483d55a88ed120e2c62b45ba5b939fa72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5b1f4e483d55a88ed120e2c62b45ba5b939fa72
Gitweb:     http://git.kernel.org/tip/f5b1f4e483d55a88ed120e2c62b45ba5b939fa72
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Mon, 7 Apr 2014 14:55:22 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Tue, 22 Apr 2014 17:39:16 +0200

perf tools: Use cpu/possible instead of cpu/kernel_max

The system's max configuration is represented by cpu/possible and
cpu/kernel_max can be huge (4096 vs. 128), so save space by keeping
smaller structures.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1396896924-129847-3-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 526da02..c4e55b7 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -365,7 +365,7 @@ static void set_max_cpu_num(void)
 		goto out;
 
 	/* get the highest possible cpu number for a sparse allocation */
-	ret = snprintf(path, PATH_MAX, "%s/devices/system/cpu/kernel_max", mnt);
+	ret = snprintf(path, PATH_MAX, "%s/devices/system/cpu/possible", mnt);
 	if (ret == PATH_MAX) {
 		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
 		goto out;
