Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3IZMbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:31:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab3IZMbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:31:17 -0400
Date: Thu, 26 Sep 2013 14:30:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Vince Weaver <vince@deater.net>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/21] perf: Add event toggle ioctl interface
Message-ID: <20130926123056.GE1067@krava.brq.redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <1380113447-17144-7-git-send-email-jolsa@redhat.com>
 <alpine.DEB.2.02.1309251545440.21782@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309251545440.21782@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 03:46:58PM -0400, Vince Weaver wrote:
> On Wed, 25 Sep 2013, Jiri Olsa wrote:
> 
> > --- a/include/uapi/linux/perf_event.h
> > +++ b/include/uapi/linux/perf_event.h
> > @@ -325,6 +325,7 @@ struct perf_event_attr {
> >  #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
> >  #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
> >  #define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
> > +#define PERF_EVENT_IOC_SET_TOGGLE	_IOW('$', 8, u64 *)
> 
> I'm pretty sure this should be __u64 or else it won't compile
> in userspace.

hum, we define u64 in perf 'util/types.h', that's why I missed that..
I'll send a fix for the PERF_EVENT_IOC_ID as well

thanks,
jirka
