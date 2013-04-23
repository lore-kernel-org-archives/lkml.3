Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab3DWNH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:07:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab3DWNHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:07:23 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nA3IcBR-NbkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=0i8_NddSom4A:10 a=57SyGIRnAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=F8xQYWAtFSodTeHq3K0A:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366722440.9609.148.camel@gandalf.local.home>
Subject: Re: [PATCH 02/14] perf util: Use evsel->name to get tracepoint_paths
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Date: Tue, 23 Apr 2013 09:07:20 -0400
In-Reply-To: <1366705872-12132-3-git-send-email-namhyung@kernel.org>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	 <1366705872-12132-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 17:31 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Most tracepoint events already have their system and event name in
> ->name field so that searching whole event tracing directory for each
> evsel to match given id is suboptimal.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/trace-event-info.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index ab18bf12d54a..dcfc1869c9af 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -414,12 +414,31 @@ get_tracepoints_path(struct list_head *pattrs)
>  		if (pos->attr.type != PERF_TYPE_TRACEPOINT)
>  			continue;
>  		++nr_tracepoints;
> +
> +		if (pos->name && strchr(pos->name, ':')) {
> +			char *str = strchr(pos->name, ':');

Why not make the above into:

	if (pos->name && (str = strchr(pos->name, ':'))) {

?

-- Steve



