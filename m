Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbaKUPTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:19:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:43029 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbaKUPTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:19:44 -0500
Date: Fri, 21 Nov 2014 12:19:37 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V3 2/3] perf tool: Move cpumode resolve code to
 add_callchain_ip
Message-ID: <20141121151937.GA18625@kernel.org>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
 <1415972652-17310-3-git-send-email-kan.liang@intel.com>
 <20141118082454.GB27645@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F07701674486@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701674486@SHSMSX103.ccr.corp.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 21, 2014 at 03:06:08PM +0000, Liang, Kan escreveu:
> 
> 
> > -----Original Message-----
> > From: Jiri Olsa [mailto:jolsa@redhat.com]
> > Sent: Tuesday, November 18, 2014 3:25 AM
> > To: Liang, Kan
> > Cc: acme@kernel.org; a.p.zijlstra@chello.nl; eranian@google.com; linux-
> > kernel@vger.kernel.org; mingo@redhat.com; paulus@samba.org;
> > ak@linux.intel.com
> > Subject: Re: [PATCH V3 2/3] perf tool: Move cpumode resolve code to
> > add_callchain_ip
> > 
> > On Fri, Nov 14, 2014 at 08:44:11AM -0500, kan.liang@intel.com wrote:
> > > From: Kan Liang <kan.liang@intel.com>
> > >
> > > Move the cpumode resolve code to add_callchain_ip function.
> > > No change in behavior.
> > >
> > > Signed-off-by: Kan Liang <kan.liang@intel.com>
> > > ---
> > >  tools/perf/util/machine.c | 62
> > > ++++++++++++++++++++++-------------------------
> > >  1 file changed, 29 insertions(+), 33 deletions(-)
> > >
> > > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > > index d97309c..dd8496a 100644
> > > --- a/tools/perf/util/machine.c
> > > +++ b/tools/perf/util/machine.c
> > > @@ -1384,11 +1384,35 @@ struct mem_info
> > *sample__resolve_mem(struct
> > > perf_sample *sample,  static int add_callchain_ip(struct thread *thread,
> > >  			    struct symbol **parent,
> > >  			    struct addr_location *root_al,
> > > -			    int cpumode,
> > > +			    u8 cpumode,
> > 
> > Andi's patch got in:
> > b3340a5 perf callchain: Support handling complete branch stacks as
> > histograms
> > 
> > and it uses the cpumode check for -1, so it needs to stay int, otherwise
> > there's a compilation failure:
> > 
> >   CC       util/machine.o
> > util/machine.c: In function ‘add_callchain_ip’:
> > util/machine.c:1419:14: error: comparison is always false due to limited
> > range of data type [-Werror=type-limits]
> >   if (cpumode == -1)
> >               ^
> > 
> 
> Hi Arnaldo and Jirka,
> 
> According to recent feedback, the LBR call stack V4 patch only need to do small
> change. However, it looks the patch "b3340a5 perf callchain: Support handling
> complete branch stacks as histograms" has been removed from perf/core.

Yeah, I should have left it on a separate branch while testing was
underway, my bad.
 
> Should I wait for the patch to merge again and submit the V5 patch then, OR
> Should I rebase the V5 to the latest perf/core and submit it today?

I'll try to send a screenshot of the differences among

  perf report --branch-report --tui
  perf report --branch-report --stdio (or --gtk, those two matches)

As requested by Andi, that isn't noticing any difference among these
three output modes.

After this is clarified (and possibly fixed) I'll push to Ingo and then
you can move on.

- Arnaldo
