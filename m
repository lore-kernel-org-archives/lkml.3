Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab3CLTwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:52:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46997 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3CLTwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:52:37 -0400
Date: Tue, 12 Mar 2013 16:52:28 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 00/12] perf annotate: Add support for event group view
 (v2)
Message-ID: <20130312195228.GC11779@ghostprotocols.net>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
 <20130311205316.GA11779@ghostprotocols.net>
 <878v5tl2vc.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v5tl2vc.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 12, 2013 at 12:21:27PM +0900, Namhyung Kim escreveu:
> On Mon, 11 Mar 2013 17:53:16 -0300, Arnaldo Carvalho de Melo wrote:
> > I need to go thru this more thoroughly, as at least one thing caught my
> > attention, in some cases ->nr_pcnt is used and in others
> > evsel->nr_members, do we need both?

> Probably not.  I was thought keeping an array and its length together is
> better.  But it's rather a waste to save the same information to every
> date structure so I move it to the struct annotate_browser->nr_events.
 
> For evsel->nr_members, current code sets it only for grouping is enabled
> so the individual events will have value of 0.  Also it's not pass the
> evsel to every function need it.  But if you think it should really be
> fixed that way I can make the change to pass and use evsel->nr_members.

This can be left for later, my point here is that we should try to avoid
the various UIs from diverging too much, i.e. the code for --gtk,
--stdio and --tui should be as close and using the same abstractions as
possible.
 
> Anyway, below is a fixed version that could survived my testing.

indeed, works, compared the output of --stdio --group with --tui --group
and it matches.

While looking at it I noticed that the stdio output wastes the initial
columns, at some point we may want to make the hist_entry lines match
the TUI ones, so that going back and forth on two xterm tabs shows no
differences.

Anyway, thanks, applied!

- Arnaldo
