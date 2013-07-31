Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab3GaRoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:44:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760656Ab3GaRoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:44:08 -0400
Date: Wed, 31 Jul 2013 19:38:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] tracing: trace_remove_event_call() should fail
	if call/file is in use
Message-ID: <20130731173832.GA31099@redhat.com>
References: <20130729175008.GA26284@redhat.com> <1375289503.5418.6.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1375289503.5418.6.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 07/31, Steven Rostedt wrote:
>
> On Mon, 2013-07-29 at 19:50 +0200, Oleg Nesterov wrote:
> >
> > Now we are ready to change trace_kprobe.c and trace_uprobe.c, Steven
> > already has the patches.
>
> Can you refresh my memory. My INBOX is quite full. What were the
> subjects for these patches?

Please see the attached mbox. And notice who is the author ;)
I also added the ack from Masami.

But if you only need the subjects:

	[RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe event files are open
	[RFC][PATCH 4/4] tracing/uprobes: Fail to unregister if probe event files are open

Oleg.

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="old.mbox"

>From rostedt@goodmis.org Thu Jul  4 05:40:42 2013
Return-Path: rostedt@goodmis.org
Received: from zmta04.collab.prod.int.phx2.redhat.com (LHLO
 zmta04.collab.prod.int.phx2.redhat.com) (10.5.81.11) by
 zmail13.collab.prod.int.phx2.redhat.com with LMTP; Wed, 3 Jul 2013 23:40:42
 -0400 (EDT)
Received: from zmta04.collab.prod.int.phx2.redhat.com (localhost [127.0.0.1])
	by zmta04.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id AC30BD1C4E
	for <onestero@redhat.com>; Wed,  3 Jul 2013 23:40:42 -0400 (EDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by zmta04.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id A6B98D1C4B
	for <onestero@mail.corp.redhat.com>; Wed,  3 Jul 2013 23:40:42 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx14.extmail.prod.ext.phx2.redhat.com [10.5.110.19])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r643efGV017597
	for <oleg@redhat.com>; Wed, 3 Jul 2013 23:40:42 -0400
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com [71.74.56.122])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r643edMW011522
	for <oleg@redhat.com>; Wed, 3 Jul 2013 23:40:40 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=odXrFLFfAhoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BdHU2U2mihYA:10 a=Q00xHw_dJstCAtue8jQA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Received: from [67.255.60.225] ([67.255.60.225:50276] helo=gandalf.local.home)
	by hrndva-oedge02.mail.rr.com (envelope-from <rostedt@goodmis.org>)
	(ecelerity 2.2.3.46 r()) with ESMTP
	id 37/75-21735-7BEE4D15; Thu, 04 Jul 2013 03:40:39 +0000
Received: from rostedt by gandalf.local.home with local (Exim 4.80)
	(envelope-from <rostedt@goodmis.org>)
	id 1UuaPO-0007TA-T2; Wed, 03 Jul 2013 23:40:38 -0400
Message-Id: <20130704034038.819592356@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 23:33:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe event files are open
References: <20130704033347.807661713@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-kprobes-Fail-to-unregister-if-probe-event-fi.patch
X-RedHat-Spam-Score: -2.009  (BAYES_00,DCC_REPUT_13_19,RCVD_IN_DNSWL_NONE,URIBL_BLOCKED)
X-Scanned-By: MIMEDefang 2.68 on 10.5.11.25
X-Scanned-By: MIMEDefang 2.68 on 10.5.110.19
Status: RO
Content-Length: 3008
Lines: 100

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When one of the event files is opened, we need to prevent them from
being removed. Modules do with with the module owner set (automated
from the VFS layer).  The ftrace buffer instances have a ref count added
to the trace_array when the enabled file is opened (the others are not
that big of a deal, as they only reference the event calls which
still exist when an instance disappears). But kprobes and uprobes
do not have any protection.

 # cd /sys/kernel/debug/tracing
 # echo 'p:sigprocmask sigprocmask' > kprobe_events || exit -1
 # enable_probe() {
    sleep 10
    echo 1
 }
 # file=events/kprobes/sigprocmask/enable
 # enable_probe > $file &
 > kprobe_events

The above will corrupt the kprobe system, as the write to the enable
file will happen after the kprobe was deleted.

Trying to create the probe again fails:

 # echo 'p:sigprocmask sigprocmask' > kprobe_events
 # cat kprobe_events
p:kprobes/sigprocmask sigprocmask
 # ls events/kprobes/
enable  filter

Have the unregister probe fail when the event files are open, in use
are used by perf.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ed6976..ffcaf42 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -95,7 +95,7 @@ static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
 }
 
 static int register_probe_event(struct trace_probe *tp);
-static void unregister_probe_event(struct trace_probe *tp);
+static int unregister_probe_event(struct trace_probe *tp);
 
 static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
@@ -340,9 +340,12 @@ static int unregister_trace_probe(struct trace_probe *tp)
 	if (trace_probe_is_enabled(tp))
 		return -EBUSY;
 
+	/* Will fail if probe is being used by ftrace or perf */
+	if (unregister_probe_event(tp))
+		return -EBUSY;
+
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
-	unregister_probe_event(tp);
 
 	return 0;
 }
@@ -621,7 +624,9 @@ static int release_all_trace_probes(void)
 	/* TODO: Use batch unregistration */
 	while (!list_empty(&probe_list)) {
 		tp = list_entry(probe_list.next, struct trace_probe, list);
-		unregister_trace_probe(tp);
+		ret = unregister_trace_probe(tp);
+		if (ret)
+			goto end;
 		free_trace_probe(tp);
 	}
 
@@ -1242,11 +1247,15 @@ static int register_probe_event(struct trace_probe *tp)
 	return ret;
 }
 
-static void unregister_probe_event(struct trace_probe *tp)
+static int unregister_probe_event(struct trace_probe *tp)
 {
+	int ret;
+
 	/* tp->event is unregistered in trace_remove_event_call() */
-	trace_remove_event_call(&tp->call);
-	kfree(tp->call.print_fmt);
+	ret = trace_remove_event_call(&tp->call);
+	if (!ret)
+		kfree(tp->call.print_fmt);
+	return ret;
 }
 
 /* Make a debugfs interface for controlling probe points */
-- 
1.7.10.4



>From masami.hiramatsu.pt@hitachi.com Tue Jul 30 10:15:51 2013
Return-Path: masami.hiramatsu.pt@hitachi.com
Received: from zmta05.collab.prod.int.phx2.redhat.com (LHLO
 zmta05.collab.prod.int.phx2.redhat.com) (10.5.81.12) by
 zmail13.collab.prod.int.phx2.redhat.com with LMTP; Tue, 30 Jul 2013
 04:15:51 -0400 (EDT)
Received: from zmta05.collab.prod.int.phx2.redhat.com (localhost [127.0.0.1])
	by zmta05.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id C7B26F28DE;
	Tue, 30 Jul 2013 04:15:51 -0400 (EDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by zmta05.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 6B231F2A08;
	Tue, 30 Jul 2013 04:15:51 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx11.extmail.prod.ext.phx2.redhat.com [10.5.110.16])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r6U8Fo7F030049;
	Tue, 30 Jul 2013 04:15:50 -0400
Received: from mail7.hitachi.co.jp (mail7.hitachi.co.jp [133.145.228.42])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6U8FkxR015000;
	Tue, 30 Jul 2013 04:15:47 -0400
Received: from mlsv3.hitachi.co.jp (unknown [133.144.234.166])
	by mail7.hitachi.co.jp (Postfix) with ESMTP id 181D137AC6;
	Tue, 30 Jul 2013 17:15:46 +0900 (JST)
Received: from mfilter05.hitachi.co.jp by mlsv3.hitachi.co.jp (8.13.1/8.13.1) id r6U8Fke3005277; Tue, 30 Jul 2013 17:15:46 +0900
Received: from vshuts04.hitachi.co.jp (vshuts04.hitachi.co.jp [10.201.6.86])
	by mfilter05.hitachi.co.jp (Switch-3.3.4/Switch-3.3.4) with ESMTP id r6U8FfkM003254;
	Tue, 30 Jul 2013 17:15:45 +0900
Received: from gmml27.itg.hitachi.co.jp (unknown [158.213.165.130])
	by vshuts04.hitachi.co.jp (Postfix) with ESMTP id 91D9F140058;
	Tue, 30 Jul 2013 17:15:44 +0900 (JST)
Received: from [10.198.208.96] by gmml27.itg.hitachi.co.jp (AIX5.2/8.11.6p2/8.11.0) id r6U8Fix5128402; Tue, 30 Jul 2013 17:15:44 +0900
Message-ID: <51F7762E.7010906@hitachi.com>
Date: Tue, 30 Jul 2013 17:15:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
 event files are open
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org>
In-Reply-To: <20130704034038.819592356@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-RedHat-Spam-Score: -2.6  (BAYES_00,RCVD_IN_DNSWL_LOW,SPF_PASS,URIBL_BLOCKED)
X-Scanned-By: MIMEDefang 2.68 on 10.5.11.24
X-Scanned-By: MIMEDefang 2.68 on 10.5.110.16
Status: RO
Content-Length: 3609
Lines: 116

(2013/07/04 12:33), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When one of the event files is opened, we need to prevent them from
> being removed. Modules do with with the module owner set (automated
> from the VFS layer).  The ftrace buffer instances have a ref count added
> to the trace_array when the enabled file is opened (the others are not
> that big of a deal, as they only reference the event calls which
> still exist when an instance disappears). But kprobes and uprobes
> do not have any protection.
> 
>  # cd /sys/kernel/debug/tracing
>  # echo 'p:sigprocmask sigprocmask' > kprobe_events || exit -1
>  # enable_probe() {
>     sleep 10
>     echo 1
>  }
>  # file=events/kprobes/sigprocmask/enable
>  # enable_probe > $file &
>  > kprobe_events
> 
> The above will corrupt the kprobe system, as the write to the enable
> file will happen after the kprobe was deleted.
> 
> Trying to create the probe again fails:
> 
>  # echo 'p:sigprocmask sigprocmask' > kprobe_events
>  # cat kprobe_events
> p:kprobes/sigprocmask sigprocmask
>  # ls events/kprobes/
> enable  filter
> 
> Have the unregister probe fail when the event files are open, in use
> are used by perf.
> 

Now, since the commit a232e270d makes sure that disable_trace_probe()
waits until all running handlers are done, this patch has no problem.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!


> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_kprobe.c |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 7ed6976..ffcaf42 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -95,7 +95,7 @@ static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
>  }
>  
>  static int register_probe_event(struct trace_probe *tp);
> -static void unregister_probe_event(struct trace_probe *tp);
> +static int unregister_probe_event(struct trace_probe *tp);
>  
>  static DEFINE_MUTEX(probe_lock);
>  static LIST_HEAD(probe_list);
> @@ -340,9 +340,12 @@ static int unregister_trace_probe(struct trace_probe *tp)
>  	if (trace_probe_is_enabled(tp))
>  		return -EBUSY;
>  
> +	/* Will fail if probe is being used by ftrace or perf */
> +	if (unregister_probe_event(tp))
> +		return -EBUSY;
> +
>  	__unregister_trace_probe(tp);
>  	list_del(&tp->list);
> -	unregister_probe_event(tp);
>  
>  	return 0;
>  }
> @@ -621,7 +624,9 @@ static int release_all_trace_probes(void)
>  	/* TODO: Use batch unregistration */
>  	while (!list_empty(&probe_list)) {
>  		tp = list_entry(probe_list.next, struct trace_probe, list);
> -		unregister_trace_probe(tp);
> +		ret = unregister_trace_probe(tp);
> +		if (ret)
> +			goto end;
>  		free_trace_probe(tp);
>  	}
>  
> @@ -1242,11 +1247,15 @@ static int register_probe_event(struct trace_probe *tp)
>  	return ret;
>  }
>  
> -static void unregister_probe_event(struct trace_probe *tp)
> +static int unregister_probe_event(struct trace_probe *tp)
>  {
> +	int ret;
> +
>  	/* tp->event is unregistered in trace_remove_event_call() */
> -	trace_remove_event_call(&tp->call);
> -	kfree(tp->call.print_fmt);
> +	ret = trace_remove_event_call(&tp->call);
> +	if (!ret)
> +		kfree(tp->call.print_fmt);
> +	return ret;
>  }
>  
>  /* Make a debugfs interface for controlling probe points */
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



>From rostedt@goodmis.org Thu Jul  4 05:40:42 2013
Return-Path: rostedt@goodmis.org
Received: from zmta05.collab.prod.int.phx2.redhat.com (LHLO
 zmta05.collab.prod.int.phx2.redhat.com) (10.5.81.12) by
 zmail13.collab.prod.int.phx2.redhat.com with LMTP; Wed, 3 Jul 2013 23:40:42
 -0400 (EDT)
Received: from zmta05.collab.prod.int.phx2.redhat.com (localhost [127.0.0.1])
	by zmta05.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id AFC03F2D19;
	Wed,  3 Jul 2013 23:40:42 -0400 (EDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by zmta05.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id A6FF3F2D17;
	Wed,  3 Jul 2013 23:40:42 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx13.extmail.prod.ext.phx2.redhat.com [10.5.110.18])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r643egZa017120;
	Wed, 3 Jul 2013 23:40:42 -0400
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com [71.74.56.122])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r643edx3020216;
	Wed, 3 Jul 2013 23:40:40 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=kwCRlE8uItcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=e-0I92L2Hf8A:10 a=ngVV-1ifIcZ1sTZkOpAA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Received: from [67.255.60.225] ([67.255.60.225:50364] helo=gandalf.local.home)
	by hrndva-oedge03.mail.rr.com (envelope-from <rostedt@goodmis.org>)
	(ecelerity 2.2.3.46 r()) with ESMTP
	id AF/AC-07405-7BEE4D15; Thu, 04 Jul 2013 03:40:39 +0000
Received: from rostedt by gandalf.local.home with local (Exim 4.80)
	(envelope-from <rostedt@goodmis.org>)
	id 1UuaPP-0007Tl-2D; Wed, 03 Jul 2013 23:40:39 -0400
Message-Id: <20130704034038.991525256@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 23:33:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 4/4] tracing/uprobes: Fail to unregister if probe event files are open
References: <20130704033347.807661713@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-uprobes-Fail-to-unregister-if-probe-event-fi.patch
X-RedHat-Spam-Score: -1.909  (BAYES_00,RCVD_IN_DNSWL_NONE,URIBL_BLOCKED)
X-Scanned-By: MIMEDefang 2.68 on 10.5.11.22
X-Scanned-By: MIMEDefang 2.68 on 10.5.110.18
Status: RO
Content-Length: 4112
Lines: 148

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When one of the event files is opened, we need to prevent them from
being removed. Modules do with with the module owner set (automated
from the VFS layer).  The ftrace buffer instances have a ref count added
to the trace_array when the enabled file is opened (the others are not
that big of a deal, as they only reference the event calls which
still exist when an instance disappears). But kprobes and uprobes
do not have any protection.

Have the unregister probe fail when the event files are open, in use
are used by perf.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c |   48 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d5d0cd3..4916da5 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -70,7 +70,7 @@ struct trace_uprobe {
 	(sizeof(struct probe_arg) * (n)))
 
 static int register_uprobe_event(struct trace_uprobe *tu);
-static void unregister_uprobe_event(struct trace_uprobe *tu);
+static int unregister_uprobe_event(struct trace_uprobe *tu);
 
 static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
@@ -164,11 +164,17 @@ static struct trace_uprobe *find_probe_event(const char *event, const char *grou
 }
 
 /* Unregister a trace_uprobe and probe_event: call with locking uprobe_lock */
-static void unregister_trace_uprobe(struct trace_uprobe *tu)
+static int unregister_trace_uprobe(struct trace_uprobe *tu)
 {
+	int ret;
+
+	ret = unregister_uprobe_event(tu);
+	if (ret)
+		return ret;
+
 	list_del(&tu->list);
-	unregister_uprobe_event(tu);
 	free_trace_uprobe(tu);
+	return 0;
 }
 
 /* Register a trace_uprobe and probe_event */
@@ -181,9 +187,12 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
 
 	/* register as an event */
 	old_tp = find_probe_event(tu->call.name, tu->call.class->system);
-	if (old_tp)
+	if (old_tp) {
 		/* delete old event */
-		unregister_trace_uprobe(old_tp);
+		ret = unregister_trace_uprobe(old_tp);
+		if (ret)
+			goto end;
+	}
 
 	ret = register_uprobe_event(tu);
 	if (ret) {
@@ -256,6 +265,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		group = UPROBE_EVENT_SYSTEM;
 
 	if (is_delete) {
+		int ret;
+
 		if (!event) {
 			pr_info("Delete command needs an event name.\n");
 			return -EINVAL;
@@ -269,9 +280,9 @@ static int create_trace_uprobe(int argc, char **argv)
 			return -ENOENT;
 		}
 		/* delete an event */
-		unregister_trace_uprobe(tu);
+		ret = unregister_trace_uprobe(tu);
 		mutex_unlock(&uprobe_lock);
-		return 0;
+		return ret;
 	}
 
 	if (argc < 2) {
@@ -408,16 +419,20 @@ fail_address_parse:
 	return ret;
 }
 
-static void cleanup_all_probes(void)
+static int cleanup_all_probes(void)
 {
 	struct trace_uprobe *tu;
+	int ret = 0;
 
 	mutex_lock(&uprobe_lock);
 	while (!list_empty(&uprobe_list)) {
 		tu = list_entry(uprobe_list.next, struct trace_uprobe, list);
-		unregister_trace_uprobe(tu);
+		ret = unregister_trace_uprobe(tu);
+		if (ret)
+			break;
 	}
 	mutex_unlock(&uprobe_lock);
+	return ret;
 }
 
 /* Probes listing interfaces */
@@ -462,8 +477,12 @@ static const struct seq_operations probes_seq_op = {
 
 static int probes_open(struct inode *inode, struct file *file)
 {
+	int ret = 0;
+
 	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC))
-		cleanup_all_probes();
+		ret = cleanup_all_probes();
+	if (ret)
+		return ret;
 
 	return seq_open(file, &probes_seq_op);
 }
@@ -970,12 +989,17 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 	return ret;
 }
 
-static void unregister_uprobe_event(struct trace_uprobe *tu)
+static int unregister_uprobe_event(struct trace_uprobe *tu)
 {
+	int ret;
+
 	/* tu->event is unregistered in trace_remove_event_call() */
-	trace_remove_event_call(&tu->call);
+	ret = trace_remove_event_call(&tu->call);
+	if (ret)
+		return ret;
 	kfree(tu->call.print_fmt);
 	tu->call.print_fmt = NULL;
+	return 0;
 }
 
 /* Make a trace interface for controling probe points */
-- 
1.7.10.4




--7JfCtLOvnd9MIVvH--

