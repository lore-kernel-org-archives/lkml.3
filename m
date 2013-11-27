Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3K0Omm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:42:42 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:57156 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3K0Omk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:42:40 -0500
Date: Wed, 27 Nov 2013 11:42:31 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Fix not finding kcore in buildid cache
Message-ID: <20131127144231.GC11498@ghostprotocols.net>
References: <1385471964-4037-1-git-send-email-adrian.hunter@intel.com>
 <20131126161553.GB7775@gmail.com>
 <5295AACE.2080606@intel.com>
 <20131127113248.GB10495@gmail.com>
 <5295DCAD.80802@intel.com>
 <20131127115247.GA10528@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127115247.GA10528@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 27, 2013 at 12:52:47PM +0100, Ingo Molnar escreveu:
> 
> * Adrian Hunter <adrian.hunter@intel.com> wrote:
> 
> > On 27/11/13 13:32, Ingo Molnar wrote:
> > > 
> > > * Adrian Hunter <adrian.hunter@intel.com> wrote:
> > > 
> > >> On 26/11/13 18:15, Ingo Molnar wrote:
> > >>>
> > >>> * Adrian Hunter <adrian.hunter@intel.com> wrote:
> > >>>
> > >>>> The logic was not looking in the buildid cache for kcore
> > >>>> if the host kernel buildid did not match the recorded
> > >>>> kernel buildid.
> > >>>
> > >>> It would be nice to also include the specific failure mode in the 
> > >>> changelog: exactly how can users run into this. That will be more 
> > >>> useful to most people reading these changelogs than a more abstract 
> > >>> bug description.
> > >>
> > >> The preconditions for the problem are that kcore is in the buildid
> > >> cache and that the running kernel has a different buildid e.g.
> > >>
> > >> $ perf buildid-list | grep kernel.kallsyms
> > >> b18fbe769dea12513028a4287dae02efc1582c29 [kernel.kallsyms]
> > >>
> > >> $ perf record -o /tmp/junk true >/dev/null 2>&1 ; perf buildid-list -i /tmp/junk | grep kernel.kallsyms
> > >> 504f9fd9328c40714995ce76fe1354c6e90136ce [kernel.kallsyms]
> > >>
> > >>
> > >>
> > >> Before the patch:
> > >>
> > >>
> > >> $ perf script -v >out.txt
> > >> build id event received for [kernel.kallsyms]: b18fbe769dea12513028a4287dae02efc1582c29
> > >> <SNIP>
> > >> Using /home/ahunter/.debug/[kernel.kallsyms]/b18fbe769dea12513028a4287dae02efc1582c29 for symbols
> > >>
> > >> perf script stopped
> > >>
> > >>
> > >> After the patch:
> > >>
> > >>
> > >> $ perf script -v >out.txt
> > >> build id event received for [kernel.kallsyms]: b18fbe769dea12513028a4287dae02efc1582c29
> > >> <SNIP>
> > >> Using /home/ahunter/.debug/[kernel.kcore]/b18fbe769dea12513028a4287dae02efc1582c29/2013112617084061/kcore for kernel object code
> > >> Using /home/ahunter/.debug/[kernel.kcore]/b18fbe769dea12513028a4287dae02efc1582c29/2013112617084061/kallsyms for symbols
> > >>
> > >> perf script stopped
> > > 
> > > So the result of the patch is that kernel symbols get 
> > > resolved/annotated correctly, as expected from the live kcore feature, 
> > > right?
> > 
> > Yes but this is the non-live case i.e. the kernel has changed and we are
> > looking at a special copy of kcore that we placed in the buildid cache
> > (using "perf buildid-cache -v -k /proc/kcore") when the data was recorded.
> 
> Okay.

Thanks for the questions and answers, I'll edit it and add to the patch.

- Arnaldo
