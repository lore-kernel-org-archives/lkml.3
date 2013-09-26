Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984Ab3IZOGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:06:22 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:41534 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3IZOGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:06:20 -0400
Date: Thu, 26 Sep 2013 11:06:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: fix infinite loop with corrupted header
Message-ID: <20130926140613.GB26159@ghostprotocols.net>
References: <1380172836-13936-1-git-send-email-sonnyrao@chromium.org>
 <52443800.5080200@gmail.com>
 <20130926134640.GA26159@ghostprotocols.net>
 <1380203977.1810.0.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380203977.1810.0.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 26, 2013 at 10:59:37PM +0900, Namhyung Kim escreveu:
> 2013-09-26 (목), 10:46 -0300, Arnaldo Carvalho de Melo:
> > Em Thu, Sep 26, 2013 at 07:34:56AM -0600, David Ahern escreveu:
> > > On 9/25/13 11:20 PM, Sonny Rao wrote:
> > > >We recently ran into a corrupt perf data file which mostly looked okay
> > > >but the section size for data was set to 0.  This caused perf report to
> > > >get into an infinite loop in __perf_session_process_events().  Let's
> > > >just avoid this by bailing early and reporting it if there's an
> > > >invalid header.
> > > 
> > > Been suggested before:
> > > https://lkml.org/lkml/2013/5/9/405
> > 
> > Thanks for the pointer (and this latest patch as well), looking at it
> > now.
> > 
> > - Arnaldo
> >  
> > > Other changes went in around that time as well. Are you still seeing
> > > the loop on latest source?
> 
> Did you mean this?

Not at that moment, but yes, I looked up the discussion and found this,
which I think is sensible, would like just to do some testing, and if
you could submit a patch combining your change with David's, I think it
would be good.

Thanks,

- Arnaldo
 
> https://lkml.org/lkml/2013/5/9/670
> 
> 
> Thanks,
> Namhyung
> 
