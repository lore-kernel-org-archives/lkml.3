Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbbAVGwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:52:43 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:44260 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbAVGwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:52:35 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 22 Jan 2015 01:53:35 -0500 (EST)
To: Jiri Olsa <jolsa@redhat.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: behavior of poll() changed in 3.18
In-Reply-To: <20150121162108.GD6835@krava.brq.redhat.com>
Message-ID: <alpine.DEB.2.11.1501220026210.12767@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1501201155380.18043@vincent-weaver-1.umelst.maine.edu> <20150120181316.GA12860@krava.brq.redhat.com> <alpine.DEB.2.11.1501210058090.21805@vincent-weaver-1.umelst.maine.edu> <20150121162108.GD6835@krava.brq.redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Jiri Olsa wrote:
> 
> However if we revert this code, we'll loose nice (and standard) way
> to check if the event is still valid.. not sure how to handle this.

there's likely no need to revert as my code wasn't really released and 
I've already fixed it to work with the new interface.

I was mostly asking just so I could update the manpage to explain the new 
behavior, as tools that expect to be backwards compatible will have to 
handle both ways of detecting a process dieing.

> > Part of why my code doesn't just exit on POLLHUP is because you can
> > get that result for reasons other than a process exit (for example,
> > if you are using ioctl(PERF_EVENT_IOC_REFRESH)
> 
> Nope, this is related to POOL_HUP (notice the '_') which you'll get
> accompanied with SIGIO if you setup this.

So what happens if you are using a signal handler to monitor a child and 
the child exits?

It's a shame the poll and signal handler interfaces are subtly different, 
though I guess some of that is probably due to historical reasons.

Vince
