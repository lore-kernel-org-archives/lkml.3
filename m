Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3I3TEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:04:43 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36546 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3I3TEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:04:38 -0400
Date: Mon, 30 Sep 2013 21:04:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20130930190434.GA3427@gmail.com>
References: <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
 <20130930175342.GI10293@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930175342.GI10293@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Mon, Sep 30, 2013 at 10:34:27AM -0700, Linus Torvalds escreveu:
> > On Mon, Sep 30, 2013 at 10:12 AM, Arnaldo Carvalho de Melo
> > <acme@ghostprotocols.net> wrote:
> > >
> > > Checking why that strlcpy failed...
> > 
> > I don't think glibc does strlcpy. It's not a standard C function, and
> 
> My concern was more about the thinking: ``Is this red "OFF" thing a 
> problem?  I feel so much more confortable when all entries have nice 
> green "on" lights...''

Yeah, so I think we should add our internal implementation of strlcpy() as 
a __weak function instead - if the libc does not provide then we provide a 
fallback.

That should get rid of another ~50 msecs of build overhead, as failed 
feature tests are the most expensive ones.

Agreed?

Thanks,

	Ingo
