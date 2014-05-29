Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbaE2JBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520AbaE2JBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:01:44 -0400
Date: Thu, 29 May 2014 11:01:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/14] perf tools: Cache dso data file descriptor
Message-ID: <20140529090125.GB1177@krava.brq.redhat.com>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
 <1400174615-2121-7-git-send-email-jolsa@kernel.org>
 <87tx8chvzb.fsf@sejong.aot.lge.com>
 <20140527073738.GA12920@krava.brq.redhat.com>
 <87sinth2oz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sinth2oz.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:02:36AM +0900, Namhyung Kim wrote:
> On Tue, 27 May 2014 09:37:38 +0200, Jiri Olsa wrote:
> > On Tue, May 27, 2014 at 10:05:28AM +0900, Namhyung Kim wrote:
> >> Hi Jiri,
> >> 
> >> On Thu, 15 May 2014 19:23:27 +0200, Jiri Olsa wrote:
> >> 
> >> [SNIP]
> >> > +static void data_close(void)
> >> > +{
> >> > +	bool cache_fd = may_cache_fd();
> >> > +
> >> > +	if (!cache_fd)
> >> > +		close_first_dso();
> >> > +}
> >> 
> >> Why do you do this at close()?  As long as there's no attempt to open a
> >> new file, we can keep existing fd, no?
> >
> > so the way it works now is:
> >
> >  - we keep up to the 'RLIMIT_NOFILE / 2' of open dso objects
> >  - if we try to open dso and it fails, because we are out of
> >    file descriptors, we close dso objects and try to reopen
> >    (check do_open function)
> >  - when we close the dso object we check if number of opened
> >    dso objects is below 'RLIMIT_NOFILE / 2'.. if it is, we keep
> >    the dso opened, if not we close first dso in the list
> >
> > util/dso.h tries to describe that
> 
> Yes, I know.  But my question is why do this at close()?  Isn't it
> sufficient to check the file limit at open() and close previous one if
> necessary?

hm, it's still the same operation to be done either in open
or in close.. but we would not need dso__data_close then..
ok, I'll make the change ;-)

thanks,
jirka
