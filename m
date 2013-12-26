Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3LZOPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:15:17 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:43166 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3LZOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:15:15 -0500
Date: Thu, 26 Dec 2013 11:15:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
Message-ID: <20131226141507.GD30980@ghostprotocols.net>
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
 <20131220075759.GA12937@gmail.com>
 <20131223193757.GA1396@ghostprotocols.net>
 <52B8D582.9090009@gmail.com>
 <20131224125342.GC17780@ghostprotocols.net>
 <20131224133003.GA23382@ghostprotocols.net>
 <52BC390A.2000504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BC390A.2000504@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 26, 2013 at 09:11:22AM -0500, David Ahern escreveu:
> On 12/24/13, 8:30 AM, Arnaldo Carvalho de Melo wrote:
> >Em Tue, Dec 24, 2013 at 09:53:42AM -0300, Arnaldo Carvalho de Melo escreveu:
> >>>The thing to check is perf_evlist__{prepare,start}_workload notification
> >>>errors using SIGUSR1, that we need to check for in the caller, and emit
> >>>the message, no?
> >Something like this:
> >
> >1. We tell perf_evlist__prepare_workload that we want a signal if execvp
> >fails, it will be a SIGUSR1
> >
> >2. We catch that signal in 'stat' and check that we got a signal, only
> >problem so far with this signal maze is that we're getting a SIGCHLD
> >while I was expecting a SIGUSR1... I.e. the "if (signr != -1) test
> >really should be if (signr == SIGUSR1), but I'm getting a SIGCHLD there
> >and the elves are tugging me away...
> 
> Did the elves release you?
> 
> There are all kinds of failure paths with the workload functions. In
> the end I was focusing on perf-stat actually checking the rc on the
> start_workload function. If it fails, then write() failed and
> something happened to the workload process. In that case don't show
> the counters.
> 
> Handling the other error paths with appropriate messages will take
> additional effort - as you are finding. ;-)

Right, but I can't apply that patch, as it makes 'perf stat
whatever-workload' to fail, as I realized when doing a demo to someone
interested in using perf ;-\

So for now I'm not applying that one.

Ah, at this point elves are everywhere, dammit! ;-)

- Arnaldo
