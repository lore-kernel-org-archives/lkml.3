Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3F0OW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:22:59 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44877 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3F0OW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:22:58 -0400
Subject: Re: [PATCH 05/19] perf tools: Introduce new 'ftrace' tool
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <51CC4373.8000204@gmail.com>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	 <1372230862-15861-6-git-send-email-namhyung@kernel.org>
	 <51CB208A.6080403@gmail.com> <87ip1016w1.fsf@sejong.aot.lge.com>
	 <51CC4373.8000204@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jun 2013 23:22:50 +0900
Message-ID: <1372342970.1734.16.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-06-27 (목), 07:51 -0600, David Ahern:
> On 6/26/13 11:04 PM, Namhyung Kim wrote:
> > Hi David,
> >
> > On Wed, 26 Jun 2013 11:10:34 -0600, David Ahern wrote:
> >> On 6/26/13 1:14 AM, Namhyung Kim wrote:
> >>> +	const char * const ftrace_usage[] = {
> >>> +		"perf ftrace [<options>] [<command>]",
> >>> +		"perf ftrace [<options>] -- <command> [<options>]",
> >>> +		NULL
> >>> +	};
> >>> +	const struct option ftrace_options[] = {
> >>> +	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
> >>> +		   "tracer to use"),
> >>
> >> How does a user know what is a valid tracer string?
> >
> > The helpline should look like (at least):
> >
> >    "tracer to use: function_graph or function"
> 
> exactly. I would suggest making that OPT_CALLBACK as well to validate 
> the string content when options are parsed.

Did you mean it by checking /sys/kernel/debug/tracing/available_tracers?

Yes, I can do that.  But current code does not support other tracers and
it'd anyway emit warning on an invalid tracer argument.

Thanks,
Namhyung

