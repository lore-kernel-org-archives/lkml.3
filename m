Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbbAVKRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:17:38 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbAVKRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:17:30 -0500
Date: Thu, 22 Jan 2015 11:17:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: easily crash kernel with rapl event close
Message-ID: <20150122101720.GA2896@worktop.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1501211348470.22707@vincent-weaver-1.umelst.maine.edu>
 <CAMsRxfJVxUcTvpaUSvTY19Ha93J1R-=o97hO+bfgkL3zU7Nrpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxfJVxUcTvpaUSvTY19Ha93J1R-=o97hO+bfgkL3zU7Nrpw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:13:11PM -0800, Stephane Eranian wrote:
> Vince,
> 
> On Wed, Jan 21, 2015 at 10:55 AM, Vince Weaver <vincent.weaver@maine.edu> wrote:
> > Hello
> >
> > on my haswell system, running 3.19-rc5, and with
> >         echo "0" > /proc/sys/kernel/perf_event_paranoid
> >
> > I can easily crash my system with the attached test program that simply
> > opens a RAPL event and then closes it.
> >
> > This bug was found by the perf_fuzzer.
> >
> > It looks like somehow rapl_pmu gets freed to NULL but the
> > call in rapl_scale()
> >         __this_cpu_read(rapl_pmu->hw_unit)
> > still happens.
> >
> I don't see how this can happen.
> 
> I get some crashes but not with your program on my laptop.
> But I cannot catch the serial console from my laptop.
> Will try with another machine tomorrow.

I saw it today as well on an ivb-ep. I disabled rapl for now since I'm
chasing other things.
