Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3EJJK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:10:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3EJJKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:10:55 -0400
Date: Fri, 10 May 2013 11:10:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/9] perf tools: Add a precise event qualifier
Message-ID: <20130510091027.GC1040@krava.brq.redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <1368106344-23383-5-git-send-email-jolsa@redhat.com>
 <877gj77gov.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gj77gov.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 10:43:28AM +0900, Namhyung Kim wrote:
> On Thu,  9 May 2013 15:32:19 +0200, Jiri Olsa wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Add a precise qualifier, like cpu/event=0x3c,precise=1/
> >
> > This is needed so that the kernel can request enabling PEBS
> > for TSX events. The parser bails out on any sysfs parse errors,
> > so this is needed in any case to handle any event on the TSX
> > perf kernel.
> [SNIP]
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -568,6 +568,12 @@ do {								\
> >  	case PARSE_EVENTS__TERM_TYPE_NAME:
> >  		CHECK_TYPE_VAL(STR);
> >  		break;
> > +	case PARSE_EVENTS__TERM_TYPE_PRECISE:
> > +		CHECK_TYPE_VAL(NUM);
> > +		if ((unsigned)term->val.num > 2)
> 
> Shouldn't it be 3 as we technically allow the 'ppp' modifier?  Although
> there's no cpu suppports precise=3 currently, things can be changed. :)

ok

jirka

> 
> Thanks,
> Namhyung
> 
