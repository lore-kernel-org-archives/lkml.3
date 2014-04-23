Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaDWGJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:09:46 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46164 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaDWGJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:09:44 -0400
Date: Wed, 23 Apr 2014 08:09:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 0/9] perf tools: Fixup for the --percentage change
Message-ID: <20140423060938.GA20455@gmail.com>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
 <20140422095557.GB10813@gmail.com>
 <87k3agsla6.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3agsla6.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Ingo,
> 
> On Tue, 22 Apr 2014 11:55:57 +0200, Ingo Molnar wrote:
> > I gave it some quick testing and after fixing a trivial merge conflict 
> > in tools/lib/lockdep/Makefile all seems to be working fine.
> 
> Thanks for testing!
> 
> >
> > But while looking at it I remembered one of my old UI complains about 
> > perf top and report, the hard to read nature of:
> >
> >    Event count (approx.): 226958779
> >
> > the values displayed are typically way too large to be easily human 
> > readable. More importantly, they are also nonsensical! That we have a 
> > sampling interval and can sum up all the intervals sampled has very 
> > little meaning to the overwhelming majority of humans looking at the 
> > data.
> >
> > And printing that just spams the visual field and confuses people.
> >
> > People care about the quality and speed of sampling itself, not 
> > directly the interval of sampling (which will often be variable with 
> > auto-freq sampling).
> 
> You meant 'period' by 'interval', right?

Yeah.

> There's --show-total-period option (should be equivalent to -F period
> later) in perf report, so there might be people want to see the numbers
> IMHO.
> 
> >
> > So instead of:
> >
> >   Samples: 42K of event 'cycles', Event count (approx.): 226958779
> >
> > How about only printing this in 'perf top' and 'perf report':
> >
> >   Captured 42.1K 'cycles' event samples
> >
> > Note the extra decimal (which helps monitor smaller changes as well), 
> > and note the different wording.
> >
> > Thoughts?
> 
> Well, I'm okay to add the extra decimal, but it seems that it only makes
> sense when the unit is 'K'..
> 
> And I think it might be worth adding filtered sample count as well if
> filtering is enabled something like:
> 
>   Captured 13.2K/42.1K 'cycles' event samples

Yeah. Maybe make it:

    Filtered 13.2K out of 42.1K 'cycles' event samples

or so.

Thanks,

	Ingo
