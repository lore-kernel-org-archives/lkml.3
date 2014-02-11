Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaBKMO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:14:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaBKMOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:14:25 -0500
Date: Tue, 11 Feb 2014 10:14:11 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
Message-ID: <20140211121411.GA4368@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
 <20140206135627.GA26955@infradead.org>
 <CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
 <20140206140705.GB26955@infradead.org>
 <20140206140936.GC26955@infradead.org>
 <CABPqkBRwy=0pnmm657TwV25GiYbpkqC1E8+cUGLEUbqxO=Gusw@mail.gmail.com>
 <52F3CAE3.7060007@gmail.com>
 <20140210210358.GD3202@infradead.org>
 <52F987CE.7010300@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F987CE.7010300@hurleysoftware.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 10, 2014 at 09:15:42PM -0500, Peter Hurley escreveu:
> >Bisected it down to:

> >eb3e4668bd9e0bbda592e830e889f137e44ec9e4 is the first bad commit
> >Author: Peter Hurley <peter@hurleysoftware.com>
> >Date:   Mon Dec 2 14:24:42 2013 -0500

> >     n_tty: Un-inline slow-path n_tty_receive_char()

> >In a hurry now, will continue later, trying to understand what is the problem
> >introduced by the above cset...

> >Need to revert just this one to confirm that it is the culprit, etc.

> Thanks for the report and bisect. Seems unlikely this commit is the
> cause, but very likely to be some change I made since 3.13, since
> I can repro on 3.14-rc1 but not on 3.13.2 -stable. I can also repro
> this on 3.12 + the patch stack from me for 3.13 and 3.14.

> I'm looking into this now.

I just reverted just this cset and the problem persisted, so I'll wait
for you on this one :-)

- Arnaldo
