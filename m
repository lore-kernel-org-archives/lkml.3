Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3JWOXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab3JWOXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:23:19 -0400
Date: Wed, 23 Oct 2013 12:22:52 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
Message-ID: <20131023142251.GA4034@infradead.org>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
 <20131010180049.GD9929@pd.tnic>
 <20131016124627.GA2611@gmail.com>
 <CABPqkBRQcisi8ukhD=6fKMq+iqwM+Qgxd3=jo82EUJB5coXs1A@mail.gmail.com>
 <20131016175302.GB4100@infradead.org>
 <CABPqkBSs1YwTiy_nkyXc89vg8-Tg=ONqCk930A+ksoLKsGLdHw@mail.gmail.com>
 <20131017081420.GB22705@gmail.com>
 <CABPqkBTBqEUU9p3SwNTXwwJ9j7VQXdofA5DzyoDmw+xJBE-uUw@mail.gmail.com>
 <20131022221803.GA3824@infradead.org>
 <CABPqkBSSFFVHH657-bvis4sSz9av4V4ziG4TVdmMZhO4LMfAdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSSFFVHH657-bvis4sSz9av4V4ziG4TVdmMZhO4LMfAdw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 23, 2013 at 11:34:42AM +0200, Stephane Eranian escreveu:
> On Wed, Oct 23, 2013 at 12:18 AM, Arnaldo Carvalho de Melo
> > What about:

> >  # perf stat -a -e power/energy-cores/,power/energy-pkg/,ref-cycles -I 1000 sleep 1000
> >  #           time                     events
> >       1.000264953              2.09 Joules power/energy-cores/
> >       1.000264953              5.94 Joules power/energy-pkg/
> >       1.000264953       160,530,320 ref-cycles
> >       2.000640422              2.07 Joules power/energy-cores/
> >       2.000640422              5.94 Joules power/energy-pkg/
> >       2.000640422       152,673,056 ref-cycles
> >       3.000964416              2.08 Joules power/energy-cores/
> >       3.000964416              5.93 Joules power/energy-pkg/
> >       3.000964416       158,779,184 ref-cycles

> > ?
> > Or even 2.09J power/energy-cores/?

> I can try that.

> > I.e. a perf_evsel__fprintf_value(evsel) would append a unit string, if
> > available.

> I don't have this function is my tree yet (tip.git).

That would be a new one :-)

At some point I'll study the %pM, etc things in the kernel printk code
to come up with something like perf_evsel__{f,scn}printf that allows us
to use just one string format and then pick things like units as a
modifier, but till then having these fprintf variants seems good enough.

- Arnaldo
