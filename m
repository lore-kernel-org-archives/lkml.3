Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3JBKLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:11:44 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51704 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3JBKLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:11:42 -0400
Date: Wed, 2 Oct 2013 12:11:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20131002101137.GB24445@gmail.com>
References: <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20131002092608.GA10099@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002092608.GA10099@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> > @@ -388,7 +410,7 @@ else
> >            has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
> >            ifeq ($(has_cplus_demangle),y)
> >              EXTLIBS += -liberty
> > -            CFLAGS += -DHAVE_CPLUS_DEMANGLE
> > +            CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
> >            else
> >              msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
> >              CFLAGS += -DNO_DEMANGLE
> > @@ -400,30 +422,29 @@ else
> >  endif
> 
> Why not add tests for 
> has_bfd_iberty/has_bfd_iberty_z/has_cplus_demangle?

Yeah, did not get to that stage yet: I only converted the feature tests 
that trigger on my system (which is about 80% of them). Will complete the 
transition.

> We could remove the config/feature-tests.mak completely and other 
> cleanup like remove try-cc.

Yeah - that will be a nice simplification!

Thanks,

	Ingo
