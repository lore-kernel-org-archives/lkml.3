Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaKTUwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:52:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:57580 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbaKTUwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:52:10 -0500
Date: Thu, 20 Nov 2014 17:52:06 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Fix segfault due to invalid kernel dso access
Message-ID: <20141120205206.GO3790@kernel.org>
References: <1416285028-30572-1-git-send-email-namhyung@kernel.org>
 <87wq6qnzfv.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wq6qnzfv.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 20, 2014 at 03:44:36PM +0900, Namhyung Kim escreveu:
> Arnaldo,
> 
> Could you please consider applying this?

Right, I should've added this to the previous pull req, will be on the
next.

- Arnaldo
 
> Thanks,
> Namhyung
> 
> 
> On Tue, 18 Nov 2014 13:30:28 +0900, Namhyung Kim wrote:
> > Jiri reported that the commit 96d78059d6d9 ("perf tools: Make vmlinux
> > short name more like kallsyms short name") segfaults on perf script.
> >
> > When processing kernel mmap event, it should access the 'kernel'
> > variable as sometimes it cannot find a matching dso from build-id
> > table so 'dso' might be invalid.
> >
> > Reported-by: Jiri Olsa <jolsa@redhat.com>
> > Tested-by: Jiri Olsa <jolsa@redhat.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/machine.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > index 52e94902afb1..85033d80fd6a 100644
> > --- a/tools/perf/util/machine.c
> > +++ b/tools/perf/util/machine.c
> > @@ -1106,8 +1106,8 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
> >  		if (__machine__create_kernel_maps(machine, kernel) < 0)
> >  			goto out_problem;
> >  
> > -		if (strstr(dso->long_name, "vmlinux"))
> > -			dso__set_short_name(dso, "[kernel.vmlinux]", false);
> > +		if (strstr(kernel->long_name, "vmlinux"))
> > +			dso__set_short_name(kernel, "[kernel.vmlinux]", false);
> >  
> >  		machine__set_kernel_mmap_len(machine, event);
