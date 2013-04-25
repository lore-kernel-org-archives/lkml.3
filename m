Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab3DYNFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:05:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab3DYNFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:05:24 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LKwk6uaGbn4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mbomyTfwWgEA:10 a=8yCgPGfcuxz2_EMbzW4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366895121.10248.12.camel@gandalf.local.home>
Subject: Re: [PATCH 05/14] perf tools: Introduce new 'ftrace' tool
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Date: Thu, 25 Apr 2013 09:05:21 -0400
In-Reply-To: <87r4hz7xal.fsf@sejong.aot.lge.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	 <1366705872-12132-6-git-send-email-namhyung@kernel.org>
	 <20130424140918.GF971@krava.brq.redhat.com>
	 <87fvyf9maa.fsf@sejong.aot.lge.com>
	 <20130425090956.GA1033@krava.brq.redhat.com>
	 <87r4hz7xal.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 18:51 +0900, Namhyung Kim wrote:
> >
> >> 
> >> Do you mean it should be changed to
> >> 
> >> 	if (write_tracing_file("set_ftrace_pid", "-1") < 0)
> >> 
> >> ?  It seems it's the right thing to do for compatibility.
> >
> >
> > looks like it's enough only to open it with O_TRUNC,
> > so I guess whatever minimal goes write_tracing_file

Correct.

> 
> Yeah, but I can see below from trace-cmd code.
> 
> trace-cmd/trace-record.c:
> 
> 	/*
> 	 * Older kernels required "-1" to disable pid
> 	 */
> 	if (ret < 0 && !strlen(pid))
> 		ret = write(fd, "-1", 2);
> 
> 
> Could you clarify this, Steve?

As the comment states, older kernels (before 2.6.33) required a -1. As
trace-cmd is set up to work with at least 2.6.32, it requires the "-1"
write. It doesn't hurt to have it.

But for perf ftrace (or whatever), I don't think we need the requirement
to work with 2.6.32 kernels. Perf was added in 2.6.31, but do all
functionalities still work that far back?

-- Steve


