Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab3IZNCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:02:23 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:59871 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756831Ab3IZNCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:02:22 -0400
Date: Thu, 26 Sep 2013 09:03:57 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Jiri Olsa <jolsa@redhat.com>
cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/21] perf: Add event toggle ioctl interface
In-Reply-To: <20130926123056.GE1067@krava.brq.redhat.com>
Message-ID: <alpine.DEB.2.02.1309260902200.15689@pianoman.cluster.toy>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com> <1380113447-17144-7-git-send-email-jolsa@redhat.com> <alpine.DEB.2.02.1309251545440.21782@pianoman.cluster.toy> <20130926123056.GE1067@krava.brq.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.5244305D.012D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Jiri Olsa wrote:

> On Wed, Sep 25, 2013 at 03:46:58PM -0400, Vince Weaver wrote:
> > On Wed, 25 Sep 2013, Jiri Olsa wrote:
> > 
> > > --- a/include/uapi/linux/perf_event.h
> > > +++ b/include/uapi/linux/perf_event.h
> > > @@ -325,6 +325,7 @@ struct perf_event_attr {
> > >  #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
> > >  #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
> > >  #define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
> > > +#define PERF_EVENT_IOC_SET_TOGGLE	_IOW('$', 8, u64 *)
> > 
> > I'm pretty sure this should be __u64 or else it won't compile
> > in userspace.
> 
> hum, we define u64 in perf 'util/types.h', that's why I missed that..
> I'll send a fix for the PERF_EVENT_IOC_ID as well

I sent in a fix for that recently and I think it's upstream already.

That's why I noticed the issue when reviewing the perf_event.h changes.

Vince
