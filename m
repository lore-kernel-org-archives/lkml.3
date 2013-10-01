Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3JAQvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:51:45 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57975 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3JAQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:51:43 -0400
Date: Tue, 1 Oct 2013 13:51:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Set child_pid after
 perf_evlist__prepare_workload()
Message-ID: <20131001165133.GE2920@ghostprotocols.net>
References: <1380531671-28076-1-git-send-email-namhyung@kernel.org>
 <524980ED.2000507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524980ED.2000507@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 30, 2013 at 07:47:25AM -0600, David Ahern escreveu:
> On 9/30/13 3:01 AM, Namhyung Kim wrote:
> >From: Namhyung Kim <namhyung.kim@lge.com>
> >
> >The commit acf2892270dc ("perf stat: Use perf_evlist__prepare/
> >start_workload()") converted to use the function but forgot to update
> >child_pid.  Fix it.
> >
> >Cc: David Ahern <dsahern@gmail.com>
> >Cc: Stephane Eranian <eranian@google.com>
> >Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> >---
> >  tools/perf/builtin-stat.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> >index f686d5ff594e..5098f144b92d 100644
> >--- a/tools/perf/builtin-stat.c
> >+++ b/tools/perf/builtin-stat.c
> >@@ -457,6 +457,7 @@ static int __run_perf_stat(int argc, const char **argv)
> >  			perror("failed to prepare workload");
> >  			return -1;
> >  		}
> >+		child_pid = evsel_list->workload.pid;
> >  	}
> >
> >  	if (group)
> >
> 
> Interesting. I can't find a test case where is matters ... perhaps a
> convenience of waitpid taking -1.

Yeah, the interval part initially used the fork return, then after
acf2892270dc used the default value of child_pid, -1, which is ok as it
waits for any children, but I wonder what would happen in workloads with
multiple children.

But for correctness acf2892270dc should have kept the existing
semantics, even if using -1 could in the end be ok.

- Arnaldo
