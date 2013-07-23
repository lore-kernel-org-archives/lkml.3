Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3GWAor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:44:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3GWAop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:44:45 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=q-5KwEyaYmUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PzHPlaRu3OEA:10 a=mk4uuN6VODAZT9Q9WYUA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374540283.3356.115.camel@gandalf.local.home>
Subject: Re: [PATCH 1/7] tracing: Introduce trace_create_cpu_file() and
 tracing_get_cpu()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 20:44:43 -0400
In-Reply-To: <20130722171549.GB27080@redhat.com>
References: <20130722134342.GA18355@redhat.com>
	 <1374506617.3356.97.camel@gandalf.local.home>
	 <20130722171549.GB27080@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 19:15 +0200, Oleg Nesterov wrote:

> > Otherwise, you might want to fix them if you need
> > to send a follow up patch set.
> 
> Yes, will do.
> 

After applying your patches, my tests crashed the kernel. It's fixed
with the following update. I guess you should merge this into your next
version.

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5e5ff44..db561b5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2984,7 +2984,7 @@ static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct trace_array *tr = inode->i_private;
 	struct seq_file *m = file->private_data;
-	struct trace_iterator *iter = m->private;
+	struct trace_iterator *iter;
 	int cpu;
 
 	if (!(file->f_mode & FMODE_READ)) {
@@ -2992,6 +2992,9 @@ static int tracing_release(struct inode *inode, struct file *file)
 		return 0;
 	}
 
+	/* Writes do not use seq_file */
+	iter = m->private;
+
 	mutex_lock(&trace_types_lock);
 
 	for_each_tracing_cpu(cpu) {


