Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3HEGAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:00:30 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44381 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3HEGA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:00:29 -0400
Message-ID: <51FF3F79.6090202@hitachi.com>
Date: Mon, 05 Aug 2013 15:00:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 04/13] tracing/kprobes: Factor out struct trace_probe
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org> <1375261410-11219-5-git-send-email-namhyung@kernel.org>
In-Reply-To: <1375261410-11219-5-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/31 18:03), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There are functions that can be shared to both of kprobes and uprobes.
> Separate common data structure to struct trace_probe and use it from
> the shared functions.

Thanks, basically I'm good at this change.
Could you also rename several functions which handles trace_kprobe
instead of trace_probe? (as you did on trace_probe_XXX())
e.g.

> @@ -107,14 +91,14 @@ static int kretprobe_dispatcher(struct kretprobe_instance *ri,
>  /*
>   * Allocate new trace_probe and initialize it (including kprobes).
>   */
> -static struct trace_probe *alloc_trace_probe(const char *group,
> +static struct trace_kprobe *alloc_trace_probe(const char *group,

Now this allocates trace_kprobe instead of trace_probe, so
this should be called as alloc_trace_kprobe().
Below functions should also be renamed.

> -static void free_trace_probe(struct trace_probe *tp)
> +static void free_trace_probe(struct trace_kprobe *tp)

> -static struct trace_probe *find_trace_probe(const char *event,
> -					    const char *group)
> +static struct trace_kprobe *find_trace_probe(const char *event,
> +					     const char *group)

> -enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
> +enable_trace_probe(struct trace_kprobe *tp, struct ftrace_event_file *file)

> -disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
> +disable_trace_probe(struct trace_kprobe *tp, struct ftrace_event_file *file)

>  /* Internal register function - just handle k*probes and flags */
> -static int __register_trace_probe(struct trace_probe *tp)
> +static int __register_trace_probe(struct trace_kprobe *tp)

>  /* Internal unregister function - just handle k*probes and flags */
> -static void __unregister_trace_probe(struct trace_probe *tp)
> +static void __unregister_trace_probe(struct trace_kprobe *tp)

For below two, comments should be updated too.

>  /* Unregister a trace_probe and probe_event: call with locking probe_lock */
> -static int unregister_trace_probe(struct trace_probe *tp)
> +static int unregister_trace_probe(struct trace_kprobe *tp)

>  /* Register a trace_probe and probe_event */
> -static int register_trace_probe(struct trace_probe *tp)
> +static int register_trace_probe(struct trace_kprobe *tp)

> @@ -399,7 +383,7 @@ static int trace_probe_module_callback(struct notifier_block *nb,
>  				       unsigned long val, void *data)

> @@ -448,7 +432,7 @@ static int create_trace_probe(int argc, char **argv)

>  static int release_all_trace_probes(void)

>  static struct ftrace_event_file *
> -find_trace_probe_file(struct trace_probe *tp, struct trace_array *tr)
> +find_trace_probe_file(struct trace_kprobe *tp, struct trace_array *tr)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


