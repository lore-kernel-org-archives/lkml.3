Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3DWP6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:58:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3DWP6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:58:03 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=xjrUfgc_UIsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=9zoxqyHsefMA:10 a=eX07Har57EoM37cZ22kA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366732681.9609.157.camel@gandalf.local.home>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Date: Tue, 23 Apr 2013 11:58:01 -0400
In-Reply-To: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 17:30 +0900, Namhyung Kim wrote:
> Hello,
> 
> This patchset implements a front-end tool for kernel's ftrace.  It
> uses function_graph tracer by default and normal function tracer is
> also supported.  (Of course you need to enable those tracers in your
> kernel first.)
> 
> NOTE: It's in very early stage, so may contain many rough edges.
> 

Very nice Namhyung, thanks for doing this. I did a quick run through of
the patches and I have no complaints about them. I'm not sure how the
others will feel about it.

Also, have you given thought on how to execute both ftrace and the pmu
counters? That is, to get a way to interleave the data?

I added a 'perf' clock to ftrace. I didn't see that being checked,
although I didn't look too hard. If possible, you can use that, as well
as the multi-buffers that are coming in 3.10.

I would also like to add a system call to allow you to get to the ftrace
data without the need for debugfs. I'm not sure if we should piggy back
on the perf system call, or add a new one. I'm thinking we should add a
new one so that it doesn't get too confusing.

Hope others have comments,

-- Steve


