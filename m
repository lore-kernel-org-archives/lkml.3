Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3LKTz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:55:57 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:64708 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3LKTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:55:53 -0500
Date: Wed, 11 Dec 2013 16:55:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 14/71] perf tools: Add cpu to struct thread
Message-ID: <20131211195546.GG1458@ghostprotocols.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-15-git-send-email-alexander.shishkin@linux.intel.com>
 <52A8BD60.80300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A8BD60.80300@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 12:30:40PM -0700, David Ahern escreveu:
> On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
> 
> >diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> >index 55f3608..52fbfb6 100644
> >--- a/tools/perf/util/machine.c
> >+++ b/tools/perf/util/machine.c
> >@@ -1412,3 +1412,29 @@ pid_t machine__get_thread_pid(struct machine *machine, pid_t tid)
> >
> >  	return thread->pid_;
> >  }
> >+
> >+int machine__get_thread_cpu(struct machine *machine, pid_t tid, pid_t *pid)
> >+{
> >+	struct thread *thread = machine__find_thread(machine, tid);
> >+
> >+	if (!thread)
> >+		return -1;
> >+
> >+	if (pid)
> >+		*pid = thread->pid_;
> 
> Why is a 'get' function modifying the thread data?

Where is this happening? :-)

My main complaint here was that we would be getting more things than
what the function name implies, see another message with my reply to
this patch.

- Arnaldo
