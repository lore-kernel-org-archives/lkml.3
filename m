Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3EPOzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:55:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3EPOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:55:47 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rEXNjEVXemUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=XC2unr7V4u4A:10 a=3nbZYyFuAAAA:8 a=hGzw-44bAAAA:8 a=20KFwNOVAAAA:8 a=h3sCQ_blAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=H8ZcNBOIOC0fbQB0rd0A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=dowx1zmaLagA:10 a=jEp0ucaQiEUA:10 a=fNChW5oJl9MA:10 a=LI9Vle30uBYA:10 a=dGJ0OcVc7YAA:10 a=0kPLrQdw3YYA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368716142.6828.98.camel@gandalf.local.home>
Subject: Re: [PATCH 2/5] perf: Reorder parameters of strglobmatch
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Irina Tirdea <irina.tirdea@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Tom Zanussi <tom.zanussi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 16 May 2013 10:55:42 -0400
In-Reply-To: <20130516114852.13508.72995.stgit@mhiramat-M0-7522>
References: <20130516114839.13508.92844.stgit@mhiramat-M0-7522>
	 <20130516114852.13508.72995.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 20:48 +0900, Masami Hiramatsu wrote:
> Reorder parameters of strglobmatch() so that the first
> parameter is the glob pattern as like as regexec(),
> because the subjective parameter of strglobmatch() must
> be the glob pattern, but not a sample string.
> So, the new interface is:

I'm a bit confused to the rational here. Can you explain in more detail
to why this patch is actually needed?

It just looks like you swapped two parameters. I still do not understand
what this was done for.

Thanks,

-- Steve

> 
> bool strglobmatch(const char *glob, const char *str);
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Irina Tirdea <irina.tirdea@intel.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/parse-events.c |   14 +++++++-------
>  tools/perf/util/probe-event.c  |    2 +-
>  tools/perf/util/strfilter.c    |    2 +-
>  tools/perf/util/string.c       |   16 ++++++++--------
>  tools/perf/util/util.h         |    4 ++--
>  5 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 6c8bb0f..26fb64a 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -402,7 +402,7 @@ static int add_tracepoint_multi_event(struct list_head **list, int *idx,
>  		    || !strcmp(evt_ent->d_name, "filter"))
>  			continue;
>  
> -		if (!strglobmatch(evt_ent->d_name, evt_name))
> +		if (!strglobmatch(evt_name, evt_ent->d_name))
>  			continue;
>  
>  		ret = add_tracepoint(list, idx, sys_name, evt_ent->d_name);
> @@ -441,7 +441,7 @@ static int add_tracepoint_multi_sys(struct list_head **list, int *idx,
>  		    || !strcmp(events_ent->d_name, "header_page"))
>  			continue;
>  
> -		if (!strglobmatch(events_ent->d_name, sys_name))
> +		if (!strglobmatch(sys_name, events_ent->d_name))
>  			continue;
>  
>  		ret = add_tracepoint_event(list, idx, events_ent->d_name,
> @@ -955,7 +955,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
>  
>  	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
>  		if (subsys_glob != NULL && 
> -		    !strglobmatch(sys_dirent.d_name, subsys_glob))
> +		    !strglobmatch(subsys_glob, sys_dirent.d_name))
>  			continue;
>  
>  		snprintf(dir_path, MAXPATHLEN, "%s/%s", tracing_events_path,
> @@ -966,7 +966,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
>  
>  		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
>  			if (event_glob != NULL && 
> -			    !strglobmatch(evt_dirent.d_name, event_glob))
> +			    !strglobmatch(event_glob, evt_dirent.d_name))
>  				continue;
>  
>  			if (name_only) {
> @@ -1065,7 +1065,7 @@ int print_hwcache_events(const char *event_glob, bool name_only)
>  			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
>  				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
>  									name, sizeof(name));
> -				if (event_glob != NULL && !strglobmatch(name, event_glob))
> +				if (event_glob != NULL && !strglobmatch(event_glob, name))
>  					continue;
>  
>  				if (name_only)
> @@ -1091,8 +1091,8 @@ static void print_symbol_events(const char *event_glob, unsigned type,
>  	for (i = 0; i < max; i++, syms++) {
>  
>  		if (event_glob != NULL && 
> -		    !(strglobmatch(syms->symbol, event_glob) ||
> -		      (syms->alias && strglobmatch(syms->alias, event_glob))))
> +		    !(strglobmatch(event_glob, syms->symbol) ||
> +		      (syms->alias && strglobmatch(event_glob, syms->alias))))
>  			continue;
>  
>  		if (name_only) {
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index aa04bf9..4d3b498 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2106,7 +2106,7 @@ static int del_trace_probe_event(int fd, const char *buf,
>  
>  	if (strpbrk(buf, "*?")) { /* Glob-exp */
>  		strlist__for_each_safe(ent, n, namelist)
> -			if (strglobmatch(ent->s, buf)) {
> +			if (strglobmatch(buf, ent->s)) {
>  				ret = __del_trace_probe_event(fd, ent);
>  				if (ret < 0)
>  					break;
> diff --git a/tools/perf/util/strfilter.c b/tools/perf/util/strfilter.c
> index 834c8eb..e50bfc5 100644
> --- a/tools/perf/util/strfilter.c
> +++ b/tools/perf/util/strfilter.c
> @@ -186,7 +186,7 @@ static bool strfilter_node__compare(struct strfilter_node *self,
>  	case '!':	/* NOT */
>  		return !strfilter_node__compare(self->r, str);
>  	default:
> -		return strglobmatch(str, self->p);
> +		return strglobmatch(self->p, str);
>  	}
>  }
>  
> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> index 29c7b2c..f4204a5 100644
> --- a/tools/perf/util/string.c
> +++ b/tools/perf/util/string.c
> @@ -223,7 +223,7 @@ error:
>  }
>  
>  /* Glob/lazy pattern matching */
> -static bool __match_glob(const char *str, const char *pat, bool ignore_space)
> +static bool __match_glob(const char *pat, const char *str, bool ignore_space)
>  {
>  	while (*str && *pat && *pat != '*') {
>  		if (ignore_space) {
> @@ -259,7 +259,7 @@ static bool __match_glob(const char *str, const char *pat, bool ignore_space)
>  		if (!*pat)	/* Tail wild card matches all */
>  			return true;
>  		while (*str)
> -			if (__match_glob(str++, pat, ignore_space))
> +			if (__match_glob(pat, str++, ignore_space))
>  				return true;
>  	}
>  	return !*str && !*pat;
> @@ -267,8 +267,8 @@ static bool __match_glob(const char *str, const char *pat, bool ignore_space)
>  
>  /**
>   * strglobmatch - glob expression pattern matching
> - * @str: the target string to match
>   * @pat: the pattern string to match
> + * @str: the target string to match
>   *
>   * This returns true if the @str matches @pat. @pat can includes wildcards
>   * ('*','?') and character classes ([CHARS], complementation and ranges are
> @@ -277,22 +277,22 @@ static bool __match_glob(const char *str, const char *pat, bool ignore_space)
>   *
>   * Note: if @pat syntax is broken, this always returns false.
>   */
> -bool strglobmatch(const char *str, const char *pat)
> +bool strglobmatch(const char *pat, const char *str)
>  {
> -	return __match_glob(str, pat, false);
> +	return __match_glob(pat, str, false);
>  }
>  
>  /**
>   * strlazymatch - matching pattern strings lazily with glob pattern
> - * @str: the target string to match
>   * @pat: the pattern string to match
> + * @str: the target string to match
>   *
>   * This is similar to strglobmatch, except this ignores spaces in
>   * the target string.
>   */
> -bool strlazymatch(const char *str, const char *pat)
> +bool strlazymatch(const char *pat, const char *str)
>  {
> -	return __match_glob(str, pat, true);
> +	return __match_glob(pat, str, true);
>  }
>  
>  /**
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index a45710b..f493590 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -239,8 +239,8 @@ int copyfile(const char *from, const char *to);
>  s64 perf_atoll(const char *str);
>  char **argv_split(const char *str, int *argcp);
>  void argv_free(char **argv);
> -bool strglobmatch(const char *str, const char *pat);
> -bool strlazymatch(const char *str, const char *pat);
> +bool strglobmatch(const char *pat, const char *str);
> +bool strlazymatch(const char *pat, const char *str);
>  int strtailcmp(const char *s1, const char *s2);
>  char *strxfrchar(char *s, char from, char to);
>  unsigned long convert_unit(unsigned long value, char *unit);


