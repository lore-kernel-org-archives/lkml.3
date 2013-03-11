Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3CKHN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:13:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25956 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3CKHN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:13:56 -0400
Message-ID: <513D8419.20400@huawei.com>
Date: Mon, 11 Mar 2013 15:13:29 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 01/13] tracing: teach to use pr_warn_once
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use pr_warn_once, instead implement it by our own.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c2e2c23..11cd56b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4588,8 +4588,6 @@ static struct dentry *d_tracer;

 struct dentry *tracing_init_dentry(void)
 {
-	static int once;
-
 	if (d_tracer)
 		return d_tracer;

@@ -4598,11 +4596,8 @@ struct dentry *tracing_init_dentry(void)

 	d_tracer = debugfs_create_dir("tracing", NULL);

-	if (!d_tracer && !once) {
-		once = 1;
-		pr_warning("Could not create debugfs directory 'tracing'\n");
-		return NULL;
-	}
+	if (!d_tracer)
+		pr_warn_once("Could not create debugfs directory 'tracing'\n");

 	return d_tracer;
 }
@@ -4611,7 +4606,6 @@ static struct dentry *d_percpu;

 static struct dentry *tracing_dentry_percpu(void)
 {
-	static int once;
 	struct dentry *d_tracer;

 	if (d_percpu)
@@ -4624,11 +4618,8 @@ static struct dentry *tracing_dentry_percpu(void)

 	d_percpu = debugfs_create_dir("per_cpu", d_tracer);

-	if (!d_percpu && !once) {
-		once = 1;
-		pr_warning("Could not create debugfs directory 'per_cpu'\n");
-		return NULL;
-	}
+	if (!d_percpu)
+		pr_warn_once("Could not create debugfs directory 'per_cpu'\n");

 	return d_percpu;
 }
-- 
1.7.9.7


