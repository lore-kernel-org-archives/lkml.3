Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3F0ONF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:13:05 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49296 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3F0ONA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:13:00 -0400
Subject: Re: [PATCH 06/19] perf ftrace: Add support for --pid option
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
In-Reply-To: <51CC44A9.60809@gmail.com>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	 <1372230862-15861-7-git-send-email-namhyung@kernel.org>
	 <51CB20F3.8000805@gmail.com> <87ehbo15zx.fsf@sejong.aot.lge.com>
	 <51CC44A9.60809@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jun 2013 23:12:52 +0900
Message-ID: <1372342372.1734.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-06-27 (목), 07:56 -0600, David Ahern:
> On 6/26/13 11:23 PM, Namhyung Kim wrote:
> > The pid filtering in ftrace is done via set_ftrace_pid file under the
> > tracing debugfs directory.  IIRC It only supports process filtering not
> > thread filtering by iterating all threads in the kernel code.  So --tid
> > option cannot be implemented as other perf commands.
> >
> > So I chose not to and assigned -t option to --tracer.
> 
> Could that ever change? With the current code why call it pid in the 
> option but assign it to target.tid? Seems a like a source for confusion 

Hmm.. right.  I did it in order not to do same iteration of the thread
group in user space.  But now I think that it's just an unnecessary
optimization and can confuse readers.


> later. Would be better to just assign to target.pid and let the 
> machinery do the right thing.

Will do.

Thanks,
Namhyung


