Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935194Ab3GWWgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:36:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717Ab3GWW1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, srikar@linux.vnet.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 073/103] uprobes: Fix return value in error handling path
Date: Tue, 23 Jul 2013 15:26:24 -0700
Message-Id: <20130723220427.764210050@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

commit fa44063f9ef163c3a4c8d8c0465bb8a056b42035 upstream.

When wrong argument is passed into uprobe_events it does not return
an error:

[root@jovi tracing]# echo 'p:myprobe /bin/bash' > uprobe_events
[root@jovi tracing]#

The proper response is:

[root@jovi tracing]# echo 'p:myprobe /bin/bash' > uprobe_events
-bash: echo: write error: Invalid argument

Link: http://lkml.kernel.org/r/51B964FF.5000106@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <srikar@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_uprobe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -283,8 +283,10 @@ static int create_trace_uprobe(int argc,
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


