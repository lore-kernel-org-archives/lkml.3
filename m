Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbbAELOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:14:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbbAELOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:14:22 -0500
Date: Mon, 5 Jan 2015 12:13:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/30] perf tools: Add new build framework support
Message-ID: <20150105111335.GB21260@krava.brq.redhat.com>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-2-git-send-email-jolsa@kernel.org>
 <20150105105751.GB19655@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105105751.GB19655@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 11:57:51AM +0100, Borislav Petkov wrote:
> On Fri, Jan 02, 2015 at 04:35:43PM +0100, Jiri Olsa wrote:
> > +a) Build makefiles
> > +------------------
> > +User supplies 'Build' makefiles that contains objects summary,
> > +like for example following 'krava/Build' file:
> > +
> > +  perf-y += a.o
> > +  perf-y += b.o
> > +
> > +The build framework is triggered by:
> > +  $ make -f Makefile.build dir=krava obj=perf
> > +
> > +which produces 'krava/perf-in.o' object file that has both
> > +a.o and b.o objects compiled in linked together.
> > +
> > +The 'Build' makefile can contains multiple objects definitions
> > +to allow building separated binaries, like:
> > +
> > +  perf-y += a.o
> > +  perf-y += b.o
> > +
> > +  libperf-y += c.o
> > +  libperf-y += d.o
> > +
> > +If the build framework is triggered by:
> > +  $ make -f Makefile.build dir=krava obj=libperf
> > +
> > +it produces 'krava/libperf-in.o' object file that has both
> > +a.o and b.o objects compiled in linked together.
> 
> Ok, question: you say those "Build" files are supplied by the user. Does
> that mean that everyone has to go and write their own or are we still
> using Kconfig and doing it in a more user-friendly manner?

there's no Kconfig involved in perf build at this moment..

the 'Build' Makefiles are equivalents of Kbuild/Makefile makefiles
within the kernel build system.. I just move the 'K' out

> 
> I've probably missed this in the whole perf fastlane development... :)

the reason for this switch is to have a first step towards
easy config support 'kernel Kconfig style like' in build

also with this change it's easier to see how the perf binary
is build and what flags were used for particular object..
at least for kernel developer used to kbuild ;-)

I also believe that the support to allow just part of the perf
code in perf binary will force the less spaghetti code ;-)

jirka
