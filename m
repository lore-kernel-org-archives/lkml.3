Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbaBFT26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:28:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001AbaBFT24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:28:56 -0500
Date: Thu, 6 Feb 2014 17:28:44 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
Message-ID: <20140206192844.GB27665@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
 <20140206135627.GA26955@infradead.org>
 <CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
 <20140206140705.GB26955@infradead.org>
 <20140206140936.GC26955@infradead.org>
 <CABPqkBRwy=0pnmm657TwV25GiYbpkqC1E8+cUGLEUbqxO=Gusw@mail.gmail.com>
 <52F3CAE3.7060007@gmail.com>
 <20140206192131.GA27665@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206192131.GA27665@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 06, 2014 at 05:21:31PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Feb 06, 2014 at 10:48:19AM -0700, David Ahern escreveu:
> > On 2/6/14, 8:24 AM, Stephane Eranian wrote:
> > >On Thu, Feb 6, 2014 at 3:09 PM, Arnaldo Carvalho de Melo
> > >>>>I am using tip.git. Or try 3.11, 3.10.

> > >>But my tests are on top of:

> > >>[acme@ssdandy linux]$ uname -r
> > >>3.11.4-101.fc18.x86_64

> > >>I thought it was a 3.14ish one, building one to try there...

> > >The kernel must be 3.14-rcX, the tool can be any version.

> > I don't have time to do a git bisect, but I can narrow the window to
> > 3.13-rc6 and 3.14-rc1. Just happened to update a server yesterday.
> > perf-top --stdio runs fine on the former and shows the problem on
> > the latter.
> 
> Humm,
> 
>                 /*
>                  * Either timeout expired or we got an EINTR due to
>                  * SIGWINCH, refresh screen in both cases.
>                  */
>                 switch (poll(&stdin_poll, 1, delay_msecs)) {
 
> And poll is returning 1:
 
>    951.068 ( 0.002 ms): poll(ufds: 0x7ff660befbb0, nfds: 1, timeout_msecs: 2000) = 1

We go to the getc(stdin) and it returns EOF :-\

- Arnaldo
