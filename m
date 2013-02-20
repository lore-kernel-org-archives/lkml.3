Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3BTVxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:53:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab3BTVxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:53:20 -0500
Date: Wed, 20 Feb 2013 22:29:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf x86: Change SandyBridge and IvyBrige instructions
 event to be precise
Message-ID: <20130220212943.GB14253@krava.redhat.com>
References: <1361392794-16552-1-git-send-email-jolsa@redhat.com>
 <m2ppzuyaao.fsf@firstfloor.org>
 <CABPqkBTCJF9eF_3Nj9nV=PNqVnrcZhkZ90oJfQ6tpHzFDFgptg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTCJF9eF_3Nj9nV=PNqVnrcZhkZ90oJfQ6tpHzFDFgptg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 10:01:20PM +0100, Stephane Eranian wrote:
> On Wed, Feb 20, 2013 at 9:55 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Jiri Olsa <jolsa@redhat.com> writes:
> >
> >> Changing the default 'instructions' HW event for SandyBridge and
> >> IvyBrige to use the available precise 'instructions' event.
> >>
> >> The precise event is defined in Intel SDM as:
> >>
> >> INST_RETIRED.ALL - Precise instruction retired event with HW to
> >> reduce effect of PEBS shadow in IP distribution
> >>
> >> for both SandyBridge and IvyBrige micro-archs. It allows to use
> >> precise modifier on 'instructions' event on SandyBridge and
> >> IvyBrige micro-archs which is not possible now.
> >
> There is also the problem that on SNB, PREC_DIST must be
> taken ALONE to be correct. By that, I mean no other counter
> must be active. So I don't think it is a good idea.
> 
> Also PREC_DIST is marked as constrained to counter 2 only.
> That in effect, as Andi pointed out, will make the fixed counter
> for instruction_retired, unused because you've set a umask now.
> 
> I don't think it buys you much. People read too much into what
> PEBS gives you. I can show you examples where PEBS
> is worse than no PEBS.

well, we sort of advertise we have precise event via precise
modifier and it confused me I was not able to use it on
IvyBridge..

maybe we could export precise alias in sysfs as well which we
could check & use any time there's 'p' modifier specified

not pretty.. meeds more thinking ;-)

thanks,
jirka
