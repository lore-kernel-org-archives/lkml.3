Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3LAMVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:21:36 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:34811 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3LAMVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:21:33 -0500
Date: Sun, 1 Dec 2013 13:21:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv3 01/29] perf tools: Remove stackprotector feature check
Message-ID: <20131201122129.GA12521@gmail.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
 <1385638408-23519-2-git-send-email-jolsa@redhat.com>
 <20131129183439.GB9876@ghostprotocols.net>
 <20131130164618.GA1228@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130164618.GA1228@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Fri, Nov 29, 2013 at 03:34:39PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Nov 28, 2013 at 12:33:00PM +0100, Jiri Olsa escreveu:
> > > We use -fstack-protector-all option to enable stack protecting
> > > for all available functions. There's no reason for enabling
> > > -Wstack-protector to get warning for unprotected functions.
> > > 
> > > Removing stackprotector feature check which was used to
> > > enable the -Wstack-protector option.
> > 
> > Doesn't applies to my perf/core branch.
> 
> yep, that's that libunwind stuff messing up ;-)
> 
> attaching v3, I could resend whole rebased patchset if
> needed.. I also updated my perf/core_plugins branch
> 
> thanks,
> jirka
> 
> 
> ---
> We use -fstack-protector-all option to enable stack protecting
> for all available functions. There's no reason for enabling
> -Wstack-protector to get warning for unprotected functions.
> 
> Removing stackprotector feature check which was used to
> enable the -Wstack-protector option.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/config/Makefile                             | 5 -----
>  tools/perf/config/feature-checks/Makefile              | 6 +-----
>  tools/perf/config/feature-checks/test-stackprotector.c | 6 ------
>  3 files changed, 1 insertion(+), 16 deletions(-)
>  delete mode 100644 tools/perf/config/feature-checks/test-stackprotector.c

Acked-by: Ingo Molnar <mingo@kernel.org>

This should also speed up the feature tests by about 10-20 msecs in 
the test-all case.

Thanks,

	Ingo
