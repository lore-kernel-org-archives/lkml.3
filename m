Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaHMOPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:15:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaHMOPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:15:50 -0400
Date: Tue, 12 Aug 2014 09:24:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [BUG] perf top: -z option does not work
Message-ID: <20140812122448.GA2184@redhat.com>
References: <CABPqkBRqqz6dEYuFvJL4M+p2h-m0P09h4fDVq6-f8fZJq6NSCA@mail.gmail.com>
 <878umuf7te.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878umuf7te.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 12, 2014 at 05:09:17PM +0900, Namhyung Kim escreveu:
> Hi Stephane,
> 
> On Tue, 12 Aug 2014 06:44:34 +0200, Stephane Eranian wrote:
> > Hi,
> >
> >
> > My understanding is that the -z option is used to only print a profile
> > since the last refresh. So if I have a refresh of 5s, then it prints the profile
> > based on the samples accumulated over the last 5 seconds.
> 
> Yep, that's what I understand about the -z behavior too.
> 
> >
> > The Z mode used to be available interactively. Nowadays, it seems only
> > avail from the cmdline. But it does not work.
> 
> Hmm.. it seems the stdio supports 'z' key but TUI don't.

Problem introduced long ago when I moved 'top' to use the same hists
browser as 'report', to have all the zooming, --sort, etc goodies.

I see that Namhyung proposed a patch to fix that, will review it,
thanks!

- Arnaldo
 
> >
> > I run a simple test.
> > $ sudo perf top -z
> >
> > Then for 5s I run a cycle-burning noploop program.
> > It shows up at the top. But when it terminates, the program  still stays
> > at the top of the profile for a long time. This is not what I'd expect.
> > The noploop line should disappear in the next couple of refreshes after
> > the program has terminated.
> >
> > I am using tip.git and seeing the problem. But it seems, it's been there for a
> > long time.
> >
> > Any idea what's wrong?
> 
> Looking at the code, it only zero out the annotation info but hist
> entries.  I guess we need to check the flag and throw out existing
> entries instead of decaying.
> 
> Also I wonder about the order of decaying - shouldn't it be decayed
> before processing current entries?  It seems current code processes
> current entries first and then decays...
> 
> I'll prepare patches for this soon.
> 
> Thanks,
> Namhyung
