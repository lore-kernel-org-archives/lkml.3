Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3JHIXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:23:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36713 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3JHIXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:23:47 -0400
Date: Tue, 8 Oct 2013 10:23:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 31/50] tools/perf/build: Speed up auto-detection of
 features by adding a 'test-all' target
Message-ID: <20131008082344.GB7232@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-32-git-send-email-mingo@kernel.org>
 <20131007212731.GC2900@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007212731.GC2900@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Oct 07, 2013 at 01:56:24PM +0200, Ingo Molnar wrote:
> 
> SNIP
> 
> > +
> > +#
> > +# Print the result of the feature test:
> > +#
> > +define feature_print_code
> > +  ifeq ($(feature-$(1)), 1)
> > +    MSG := $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
> > +  else
> > +    MSG := $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
> > +  endif
> > +  $(info $(MSG))
> > +endef
> > +
> > +$(foreach feat,$(FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
> > +
> > +# newline at the end of the feature printouts:
> > +$(info )
> >  
> > -ifeq ($(stackprotector-all), 1)
> > +ifeq ($(feature-stackprotector-all), 1)
> >    CFLAGS += -fstack-protector-all
> >  endif
> 
> nit, belongs to:
>   tools/perf/build: Split out feature check: 'stackprotector-all'

Indeed, fixed.

I also fixed the next hunk:

> ifndef NO_BIONIC
>+  $(feature_check,bionic)
>   ifeq ($(feature-bionic), 1)
>     BIONIC := 1

Which was misplaced as well.

Thanks,

	Ingo
