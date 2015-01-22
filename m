Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbbAVSIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:08:22 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:57592 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbbAVSIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:08:20 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 22 Jan 2015 13:09:11 -0500 (EST)
To: Jiri Olsa <jolsa@redhat.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: behavior of poll() changed in 3.18
In-Reply-To: <20150122133455.GC2473@krava.brq.redhat.com>
Message-ID: <alpine.DEB.2.11.1501221305150.14136@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1501201155380.18043@vincent-weaver-1.umelst.maine.edu> <20150120181316.GA12860@krava.brq.redhat.com> <alpine.DEB.2.11.1501210058090.21805@vincent-weaver-1.umelst.maine.edu> <20150121162108.GD6835@krava.brq.redhat.com>
 <alpine.DEB.2.11.1501220026210.12767@vincent-weaver-1.umelst.maine.edu> <20150122133455.GC2473@krava.brq.redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Jiri Olsa wrote:

> > So what happens if you are using a signal handler to monitor a child and 
> > the child exits?
> 
> AFAICS wrt to SIGIO, we notify only with POLL_IN if there's new data
> and POLL_HUP if we reached the event_limit - the one you set with
> PERF_EVENT_IOC_REFRESH ioctl

I wrote a test for this: if you are monitoring another process with a 
SIGIO handler and the other process dies, then you get no signal for this 
at all, and in  fact depending on the timing the last valid SIGIO overflow 
event signal might get lost (in my test I usually get one fewer 
POLL_IN signal than I would get from the equivelent poll() code).

> I've actually never used the SIGIO interface in perf other than
> when I was checking your gi repo with test code ;-)

Yes, it seems that PAPI is really the only infrastructure that tries to do 
self-monitoring using the SIGIO interface.  Which shows, as it breaks now 
and then.  That was the whole reason I started writing my perf_event_test 
infrastructure in the first place.

Vince
