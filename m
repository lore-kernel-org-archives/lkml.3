Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3JAIiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:38:15 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:41915 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3JAIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:38:12 -0400
Date: Tue, 1 Oct 2013 10:38:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20131001083807.GD21793@gmail.com>
References: <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
 <CAMuHMdUe3nLFcsZL+soHC7hsjURT+3uO-PMuboSV_eGEO=XPxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUe3nLFcsZL+soHC7hsjURT+3uO-PMuboSV_eGEO=XPxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, Sep 30, 2013 at 7:34 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Mon, Sep 30, 2013 at 10:12 AM, Arnaldo Carvalho de Melo
> > <acme@ghostprotocols.net> wrote:
> >>
> >> Checking why that strlcpy failed...
> >
> > I don't think glibc does strlcpy. It's not a standard C function, and
> > it's somewhat controversial (although I dislike strncpy more with the
> > crazy zero-padding, ugh).
> 
> Indeed, e.g. on Ubuntu it's in libbsd, so you also need to #include
> <bsd/string.h> and link with -lbsd.

Well, the point of the feature test is not to pick up an external 
definition of strlcpy(), but to keep working on systems where strcpy() has 
been patched into _glibc_, where we cannot avoid linking to it. (ARCH 
Linux is such a distribution for example.)

So it's a quirk in essence - and I think marking our implementation as 
__weak ought to solve that.

Thanks,

	Ingo
