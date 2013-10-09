Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3JIGrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:47:36 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:34679 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3JIGre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:47:34 -0400
Date: Wed, 9 Oct 2013 08:47:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 32/52] tools/perf/build: Speed up auto-detection of
 features by adding a 'test-all' target
Message-ID: <20131009064731.GB20857@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-33-git-send-email-mingo@kernel.org>
 <20131008155125.GE1348@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008155125.GE1348@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Oct 08, 2013 at 12:11:02PM +0200, Ingo Molnar wrote:
> 
> SNIP
> 
> > diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> > index c65bdac..b031669 100644
> > --- a/tools/perf/config/feature-checks/Makefile
> > +++ b/tools/perf/config/feature-checks/Makefile
> > @@ -32,6 +32,9 @@ BUILD = $(CC) -o $(OUTPUT)$@ $@.c
> >  
> >  ###############################
> >  
> > +test-all:
> > +	$(BUILD) -Werror -fstack-protector -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
> > +
> 
> missing -fstack-protector-all ? ;-)

Indeed :-) Fixed.

Thanks,

	Ingo
