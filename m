Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3DAW1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:27:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab3DAW13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:27:29 -0400
Date: Tue, 2 Apr 2013 00:27:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/27] perf tools: Move programs check into
 config/Makefile
Message-ID: <20130401222703.GC20943@krava.redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
 <1364843930-17974-5-git-send-email-jolsa@redhat.com>
 <1364854190.1728.12.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364854190.1728.12.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 07:09:50AM +0900, Namhyung Kim wrote:
> 2013-04-01 (월), 21:18 +0200, Jiri Olsa:
> > Moving programs check into config/Makefile.
> 
> [SNIP]
> 
> > +RM      = rm -f
> > +MKDIR   = mkdir
> > +FIND    = find
> > +INSTALL = install
> > +FLEX    = flex
> > +BISON   = bison
> > +STRIP  ?= strip
> 
> Why does STRIP use "?=" form?
> 
> I know you just moved the line, but AFAICS it can be converted to a
> normal variable assignment, right?

not sure, I guess someone found usefull to use custom strip 

> 
> 
> > @@ -140,14 +140,6 @@ ifneq ($(MAKECMDGOALS),clean)
> >  ifneq ($(MAKECMDGOALS),tags)
> >  -include config/feature-tests.mak
> >  
> > -ifeq ($(call get-executable,$(FLEX)),)
> > -	dummy := $(error Error: $(FLEX) is missing on this system, please install it)
> > -endif
> > -
> > -ifeq ($(call get-executable,$(BISON)),)
> > -	dummy := $(error Error: $(BISON) is missing on this system, please install it)
> > -endif
> > -
> >  ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
> >  	CFLAGS := $(CFLAGS) -fstack-protector-all
> >  endif
> > diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> > index fe317c2..04bf8ac 100644
> > --- a/tools/perf/config/Makefile
> > +++ b/tools/perf/config/Makefile
> > @@ -32,3 +32,13 @@ endif
> >  ifeq ($(NO_PERF_REGS),0)
> >          BASIC_CFLAGS += -DHAVE_PERF_REGS
> >  endif
> > +
> > +-include config/feature-tests.mak
> 
> It seems now it's redundant to include this file?

The 'config/feature-tests.mak' stuff is still needed for the rest
of the Makefile at this point. Althought all the checking stuff is
moved with final patch into config/Makefile, I wanted middle commit
to stay functional.

Now I wonder if I include 'config/feature-tests.mak' from 'config/Makefile'
wether it afects top level Makefile environment or not (my initial thought).
I'll double check that and remove if necessary.

thanks,
jirka
