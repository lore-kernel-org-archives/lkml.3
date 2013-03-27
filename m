Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3C0Q44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:56:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3C0Q4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:56:55 -0400
Date: Wed, 27 Mar 2013 13:56:45 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v7 11/18] perf tools: add mem access sampling core support
Message-ID: <20130327165644.GB14744@infradead.org>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
 <1359040242-8269-12-git-send-email-eranian@google.com>
 <20130327141425.GC1092@krava.brq.redhat.com>
 <1364394014.5053.76.camel@laptop>
 <20130327143437.GE1092@krava.brq.redhat.com>
 <CABPqkBSSBdzGJtJ6HLFCM_Hhnwv1ASZ=JCX+zpWcM5X3KwZk6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSSBdzGJtJ6HLFCM_Hhnwv1ASZ=JCX+zpWcM5X3KwZk6w@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 27, 2013 at 03:48:15PM +0100, Stephane Eranian escreveu:
> On Wed, Mar 27, 2013 at 3:34 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Wed, Mar 27, 2013 at 03:20:14PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2013-03-27 at 15:14 +0100, Jiri Olsa wrote:
> > > > we have correct cpumode for sample->ip, but I think it's the
> > > > PEBS->dla (sample->addr) where we need to guess.. right?

> > > kernel mode very much fakes the cpumode/segment stuff for PEBS. PEBS
> > > assumes you're running in a linear/flat mode.

> > say we hit the sample when kernel accesses the user data, we will endup
> > with IP in kernel space and DATA ptr in user space.. in theory ;-)

> Yes, this is possible. So I think we could probably leaverage ip__resolve_ams()
> and pass the extra parameter for MAP_VARIABLE vs. MAP_FUNCTION.

BTW, I fixed up the patches (kernel and user parts) and have them in
perf/mem at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux

Hope to push it to Ingo today/tomorrow, after some more testing, thanks
Jiri for reviewing it.

Stephane, if you could give it a try again to see that the fixups I did
(documented in the commit logs, just before my Signed-off-by) are ok,
that would be good.

- Arnaldo
 
> 
> >
> > and that would need the cpumode guessing for DATA ptr, because
> > cpumode value is deduced from cs register
> >
> > jirka
