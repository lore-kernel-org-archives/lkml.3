Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbaITPpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 11:45:03 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58117 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaITPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 11:44:59 -0400
Subject: Re: [PATCH] modified error code when perf_session__new() fail
From: Namhyung Kim <namhyung@kernel.org>
To: taeung <treeze.taeung@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, jolsa@redhat.com
In-Reply-To: <541946D8.1080209@gmail.com>
References: <541946D8.1080209@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Sep 2014 00:44:55 +0900
Message-ID: <1411227895.1690.23.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Taeung,

Please CC perf maintainers when you send a perf patch.  I'm adding
Arnaldo who maintains tooling part and Jiri who suggested this change.


2014-09-17 (수), 17:31 +0900, taeung:
> Hi,
> 
> I modified error code for the requirement as below.
> 
> Author: taeung <treeze.taeung@gmail.com>
> Date:   Sat Sep 13 16:22:53 2014 +0900
> 
>       modified error code when perf_session__new() fail
> 
>          Because perf_session__new() could fail
>          for more reasons than just ENOMEM,
>          I modified error code(ENOMEM or EINVAL)
>          into -1.

Hmm.. this seems you copied output of "git show" and send it via an
email client.  I recommend you to use "git format-patch" and "git
send-email" later.

In addition, you forgot to add your Signed-off-by.

That being said I'm okay with the patch itself.  Jiri, this is what you
wanted to do, right?

Thanks,
Namhyung

> 
> 
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 1ec429f..81c9fda 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -199,7 +199,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
> 
>       session = perf_session__new(&file, false, &ann->tool);
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       machines__set_symbol_filter(&session->machines, 
> symbol__annotate_init);
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 9a5a035..3363dce 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -683,7 +683,7 @@ static int __cmd_diff(void)
>           d->session = perf_session__new(&d->file, false, &tool);
>           if (!d->session) {
>               pr_err("Failed to open %s\n", d->file.path);
> -            ret = -ENOMEM;
> +            ret = -1;
>               goto out_delete;
>           }
> 
> diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
> index 66e12f5..0f93f85 100644
> --- a/tools/perf/builtin-evlist.c
> +++ b/tools/perf/builtin-evlist.c
> @@ -28,7 +28,7 @@ static int __cmd_evlist(const char *file_name, struct 
> perf_attr_details *details
> 
>       session = perf_session__new(&file, 0, NULL);
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       evlist__for_each(session->evlist, pos)
>           perf_evsel__fprintf(pos, details, stdout);
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 9a02807..8dbdd13 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -359,7 +359,7 @@ static int __cmd_inject(struct perf_inject *inject)
> 
>       session = perf_session__new(&file, true, &inject->tool);
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       if (inject->build_ids) {
>           inject->tool.sample = perf_event__inject_buildid;
> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> index bef3376..b518f4b 100644
> --- a/tools/perf/builtin-kmem.c
> +++ b/tools/perf/builtin-kmem.c
> @@ -422,7 +422,7 @@ static int __cmd_kmem(void)
> 
>       session = perf_session__new(&file, false, &perf_kmem);
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       if (perf_session__create_kernel_maps(session) < 0)
>           goto out_delete;
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 43367eb..828e706 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -1060,7 +1060,7 @@ static int read_events(struct perf_kvm_stat *kvm)
>           .comm            = perf_event__process_comm,
>           .ordered_samples    = true,
>       };
> -    struct perf_data_file file = {
> +    struct perf_data_file file = {
>           .path = kvm->file_name,
>           .mode = PERF_DATA_MODE_READ,
>       };
> @@ -1069,7 +1069,7 @@ static int read_events(struct perf_kvm_stat *kvm)
>       kvm->session = perf_session__new(&file, false, &kvm->tool);
>       if (!kvm->session) {
>           pr_err("Initializing perf session failed\n");
> -        return -EINVAL;
> +        return -1;
>       }
> 
>       if (!perf_session__has_traces(kvm->session, "kvm record"))
> @@ -1369,7 +1369,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
>        */
>       kvm->session = perf_session__new(&file, false, &kvm->tool);
>       if (kvm->session == NULL) {
> -        err = -ENOMEM;
> +        err = -1;
>           goto out;
>       }
>       kvm->session->evlist = kvm->evlist;
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index 6148afc..49f1e30 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -862,7 +862,7 @@ static int __cmd_report(bool display_info)
>       session = perf_session__new(&file, false, &eops);
>       if (!session) {
>           pr_err("Initializing perf session failed\n");
> -        return -ENOMEM;
> +        return -1;
>       }
> 
>       if (!perf_session__has_traces(session, "lock record"))
> diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
> index 4a1a6c9..75976ce 100644
> --- a/tools/perf/builtin-mem.c
> +++ b/tools/perf/builtin-mem.c
> @@ -124,7 +124,7 @@ static int report_raw_events(struct perf_mem *mem)
>                                &mem->tool);
> 
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       if (mem->cpu_list) {
>           ret = perf_session__cpu_bitmap(session, mem->cpu_list,
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 21d830b..1a7abac 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -712,7 +712,7 @@ int cmd_report(int argc, const char **argv, const 
> char *prefix __maybe_unused)
>   repeat:
>       session = perf_session__new(&file, false, &report.tool);
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       report.session = session;
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index f57035b..77cef60 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -1725,7 +1725,7 @@ int cmd_script(int argc, const char **argv, const 
> char *prefix __maybe_unused)
> 
>       session = perf_session__new(&file, false, &script.tool);
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       if (header || header_only) {
>           perf_session__fprintf_info(session, stdout, show_full_info);
> diff --git a/tools/perf/builtin-timechart.c 
> b/tools/perf/builtin-timechart.c
> index 2f1a522..dc9a465 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -1605,7 +1605,7 @@ static int __cmd_timechart(struct timechart 
> *tchart, const char *output_name)
>       int ret = -EINVAL;
> 
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       (void)perf_header__process_sections(&session->header,
>                           perf_data_file__fd(session->file),
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 377971d..8217b5d 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -911,7 +911,7 @@ static int __cmd_top(struct perf_top *top)
> 
>       top->session = perf_session__new(NULL, false, NULL);
>       if (top->session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       machines__set_symbol_filter(&top->session->machines, symbol_filter);
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index a6c3752..9e23293 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -2220,7 +2220,7 @@ static int trace__replay(struct trace *trace)
> 
>       session = perf_session__new(&file, false, &trace->tool);
>       if (session == NULL)
> -        return -ENOMEM;
> +        return -1;
> 
>       trace->host = &session->machines.host;
> 
> Thanks,



