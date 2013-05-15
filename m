Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab3EOVV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698Ab3EOVV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:21:28 -0400
Date: Wed, 15 May 2013 23:21:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/15] perf ftrace: Add 'show' sub-command
Message-ID: <20130515212108.GB5814@krava.redhat.com>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
 <1368526439-31966-11-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368526439-31966-11-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:13:54PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 

SNIP

> +
> +static LIST_HEAD(ftrace_cpu_buffers);
> +
> +static int process_sample_show(struct perf_tool *tool,
> +			       union perf_event * event __maybe_unused,
> +			       struct perf_sample *sample,
> +			       struct perf_evsel *evsel __maybe_unused,
> +			       struct machine *machine __maybe_unused)
> +{
> +	struct perf_ftrace *ftrace;
> +	struct perf_ftrace_report *show;
> +	struct ftrace_report_arg *fra;
> +	struct stat statbuf;
> +	enum kbuffer_long_size long_size;
> +	enum kbuffer_endian endian;
> +	char buf[PATH_MAX];
> +
> +	show = container_of(tool, struct perf_ftrace_report, tool);
> +	ftrace = show->ftrace;

this seems to be exactly same routine as process_sample_report
with exception of above 2 lines.. maybe the rest of it could be
common function?

jirka
