Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3DXOJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab3DXOJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:09:37 -0400
Date: Wed, 24 Apr 2013 16:09:18 +0200
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
Subject: Re: [PATCH 05/14] perf tools: Introduce new 'ftrace' tool
Message-ID: <20130424140918.GF971@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366705872-12132-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 05:31:03PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 

SNIP

> +out:
> +	put_tracing_file(file);
> +	return ret;
> +}
> +
> +static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
> +{
> +	if (write_tracing_file("tracing_on", "0") < 0)
> +		return -1;
> +
> +	if (write_tracing_file("current_tracer", "nop") < 0)
> +		return -1;
> +
> +	if (write_tracing_file("set_ftrace_pid", " ") < 0)
> +		return -1;

I think we want to reset set_ftrace_pid file as well
probably to -1..

if I'm tracing command with this file having wrong CPU(s)
I dont get any data..

jirka
