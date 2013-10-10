Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3JJGgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:36:09 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55740 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3JJGgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:36:08 -0400
Date: Thu, 10 Oct 2013 08:36:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 48/52] tools/perf/build: Exclude MAKEFLAGS from nested
 invocation
Message-ID: <20131010063603.GA10159@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-49-git-send-email-mingo@kernel.org>
 <87k3hliqx1.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3hliqx1.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue,  8 Oct 2013 12:11:18 +0200, Ingo Molnar wrote:
> > In case the user specifies MAKEFLAGS as an environment variable,
> > or uses 'make -jN' explicitly, the options can conflict and result in:
> >
> >     BUILD: Doing 'make -j8' parallel build
> >     make[1]: warning: -jN forced in submake: disabling jobserver mode.
> >     GEN common-cmds.h
> >     make[1]: *** write jobserver: Bad file descriptor.  Stop.
> >
> > Make sure we invoke the main makefile in a pristine state.
> >
> > Users who want to do something non-standard can use the:
> >
> >   make -f Makefile.perf
> >
> > method to invoke the makefile.
> 
> Hmm... it'd be great if there's a way to detect -jN option and convert 
> it to the JOBS.

I looked hard but couldn't find any solution for that, GNU Make hides it. 
It seems to be possible on other Make platforms - so I suspect that will 
have to be a feature request to the GNU Make folks ...

Thanks,

	Ingo
