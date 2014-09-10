Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaIJJFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:05:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44230 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaIJJF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:05:28 -0400
Date: Wed, 10 Sep 2014 10:05:21 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: fix typo in pr_warning() message
Message-ID: <20140910090521.GA7766@hercules>
References: <1410299369-20029-1-git-send-email-luis.henriques@canonical.com>
 <1410301213.22675.4.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410301213.22675.4.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 03:20:13PM -0700, Joe Perches wrote:
> On Tue, 2014-09-09 at 22:49 +0100, Luis Henriques wrote:
> > Replace 'produciton' by 'production'
> > 
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> > ---
> >  kernel/trace/trace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 8a528392b1f4..f3ef80c8914c 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -2028,7 +2028,7 @@ void trace_printk_init_buffers(void)
> >  	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
> >  	pr_warning("**                                                      **\n");
> >  	pr_warning("** This means that this is a DEBUG kernel and it is     **\n");
> > -	pr_warning("** unsafe for produciton use.                           **\n");
> > +	pr_warning("** unsafe for production use.                           **\n");
> >  	pr_warning("**                                                      **\n");
> >  	pr_warning("** If you see this message and you are not debugging    **\n");
> >  	pr_warning("** the kernel, report this immediately to your vendor!  **\n");
> 
> Perhaps s/pr_warning/pr_warn/ too?

If you (and the maintainers) agree, I would rather do that in a
separate commit.

Cheers,
--
Luís

>From 6b3519353b088b5afe903d527f66c6dc18cfe068 Mon Sep 17 00:00:00 2001
From: Luis Henriques <luis.henriques@canonical.com>
Date: Wed, 10 Sep 2014 09:59:13 +0100
Subject: [PATCH] tracing: Replace pr_warning() with pr_warn()

Convert pr_warning() usage to pr_warn().

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a528392b1f4..4df394e878b6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2022,19 +2022,19 @@ void trace_printk_init_buffers(void)
 
 	/* trace_printk() is for debug use only. Don't use it in production. */
 
-	pr_warning("\n**********************************************************\n");
-	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
-	pr_warning("**                                                      **\n");
-	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
-	pr_warning("**                                                      **\n");
-	pr_warning("** This means that this is a DEBUG kernel and it is     **\n");
-	pr_warning("** unsafe for produciton use.                           **\n");
-	pr_warning("**                                                      **\n");
-	pr_warning("** If you see this message and you are not debugging    **\n");
-	pr_warning("** the kernel, report this immediately to your vendor!  **\n");
-	pr_warning("**                                                      **\n");
-	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
-	pr_warning("**********************************************************\n");
+	pr_warn("\n**********************************************************\n");
+	pr_warn("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
+	pr_warn("**                                                      **\n");
+	pr_warn("** trace_printk() being used. Allocating extra memory.  **\n");
+	pr_warn("**                                                      **\n");
+	pr_warn("** This means that this is a DEBUG kernel and it is     **\n");
+	pr_warn("** unsafe for produciton use.                           **\n");
+	pr_warn("**                                                      **\n");
+	pr_warn("** If you see this message and you are not debugging    **\n");
+	pr_warn("** the kernel, report this immediately to your vendor!  **\n");
+	pr_warn("**                                                      **\n");
+	pr_warn("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
+	pr_warn("**********************************************************\n");
 
 	/* Expand the buffers to set size */
 	tracing_update_buffers();
@@ -5895,7 +5895,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 	snprintf(cpu_dir, 30, "cpu%ld", cpu);
 	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
-		pr_warning("Could not create debugfs '%s' entry\n", cpu_dir);
+		pr_warn("Could not create debugfs '%s' entry\n", cpu_dir);
 		return;
 	}
 
@@ -6049,7 +6049,7 @@ struct dentry *trace_create_file(const char *name,
 
 	ret = debugfs_create_file(name, mode, parent, data, fops);
 	if (!ret)
-		pr_warning("Could not create debugfs '%s' entry\n", name);
+		pr_warn("Could not create debugfs '%s' entry\n", name);
 
 	return ret;
 }
@@ -6068,7 +6068,7 @@ static struct dentry *trace_options_init_dentry(struct trace_array *tr)
 
 	tr->options = debugfs_create_dir("options", d_tracer);
 	if (!tr->options) {
-		pr_warning("Could not create debugfs directory 'options'\n");
+		pr_warn("Could not create debugfs directory 'options'\n");
 		return NULL;
 	}
 
@@ -6823,7 +6823,7 @@ __init static int tracer_alloc_buffers(void)
 	if (trace_boot_clock) {
 		ret = tracing_set_clock(&global_trace, trace_boot_clock);
 		if (ret < 0)
-			pr_warning("Trace clock %s not defined, going back to default\n",
+			pr_warn("Trace clock %s not defined, going back to default\n",
 				   trace_boot_clock);
 	}
 
-- 
1.9.1

