Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3IKE35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3IKE3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:02 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Nw9eK9p1mLwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jIRk_ILCG8sA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=hPjdaMEvmhQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042857.101077486@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [029/251] uprobes: Fix return value in error handling path
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0029-uprobes-Fix-return-value-in-error-handling-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

[ Upstream commit fa44063f9ef163c3a4c8d8c0465bb8a056b42035 ]

When wrong argument is passed into uprobe_events it does not return
an error:

[root@jovi tracing]# echo 'p:myprobe /bin/bash' > uprobe_events
[root@jovi tracing]#

The proper response is:

[root@jovi tracing]# echo 'p:myprobe /bin/bash' > uprobe_events
-bash: echo: write error: Invalid argument

Link: http://lkml.kernel.org/r/51B964FF.5000106@huawei.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <srikar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # 3.5+
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..77dccfc 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -243,8 +243,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		return -EINVAL;
 	}
 	arg = strchr(argv[1], ':');
-	if (!arg)
+	if (!arg) {
+		ret = -EINVAL;
 		goto fail_address_parse;
+	}
 
 	*arg++ = '\0';
 	filename = argv[1];
-- 
1.7.10.4


