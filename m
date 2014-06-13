Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaFMJED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaFMJEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:04:00 -0400
Date: Fri, 13 Jun 2014 11:03:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 00/14] perf/core improvements and fixes
Message-ID: <20140613090328.GA1981@krava.redhat.com>
References: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
 <CAFrcx1me4uOBX89nfjfzLpA13=2wVpyyjOEvM61k6QAhQwUZEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1me4uOBX89nfjfzLpA13=2wVpyyjOEvM61k6QAhQwUZEQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:55:55PM +0200, Jean Pihet wrote:
> Hi Jiri,
> 
> 
> On 12 June 2014 17:30, Jiri Olsa <jolsa@kernel.org> wrote:
> > hi Ingo,
> > please consider pulling
> >
> > thanks,
> > jirka
> >
> > The following changes since commit 7184062b94b4bfac08715fb786fd2df399c5d6ee:
> >
> >   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-06-12 13:54:42 +0200)
> >
> > are available in the git repository at:
> >
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> >
> > for you to fetch changes up to 45dc1bb5c1d47f9519e2101f6b073bb4bb1d1f99:
> >
> >   perf tests: Add test for closing dso objects on EMFILE error (2014-06-12 16:53:23 +0200)
> >
> > ----------------------------------------------------------------
> > perf/core improvements and fixes:
> >
> > . Honor user freq/interval properly in record command (Namhyung Kim)
> >
> > . Speedup DWARF unwind (Jiri Olsa)
> Here are the results of the performance assessment on ARMv7, FWIW:
> 
> The results for unwind_speedup (v4) on ARMv7 are:
> - libunwind: between -17% in execution time for light load (i.e. using
> not-so-deep backtraces from the stress app.) and -25% for deep
> backtrace (the stress_bt app.),
> - libdw: no significant improvement (0-3% improvement).
> 
> The results for unwind_speedup (v3) on ARMv7 are:
> - libunwind: between -29% in execution time for light load (i.e. using
> not-so-deep backtraces from the stress app.) and -49% for deep
> backtrace (the stress_bt app.),
> - libdw: no significant improvement (0-2% improvement).
> 
> Note: v3 is faster than v4 by 13-25%, with and without the speed-up
> patches. The real cause has been investigated, yet.

hi,
yep, I also found the v4 to be slower, because of the
caching code in each open.. I believe the first version
you meassured was the original, that kept all dso objects
open.. now the caching code spends more cycles

also we are not mmapping dso so far.. there's the cached
read in place

please let me know if you think it's something else

thanks for testing,
jirka
