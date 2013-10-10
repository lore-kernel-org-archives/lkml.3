Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3JJHYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:24:18 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36862 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3JJHYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:24:17 -0400
Date: Thu, 10 Oct 2013 09:24:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 32/52] tools/perf/build: Speed up auto-detection of
 features by adding a 'test-all' target
Message-ID: <20131010072413.GN10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-33-git-send-email-mingo@kernel.org>
 <87siw9ir6i.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siw9ir6i.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue,  8 Oct 2013 12:11:02 +0200, Ingo Molnar wrote:
> > +test-all:
> > +	$(BUILD) -Werror -fstack-protector -Wvolatile-register-var -O2 
> > -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 
> > -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs 
> > --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) 
> > $(FLAGS_PYTHON_EMBED) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
> 
> Also missed -Wstack-protector.  And duplicate -Werror.
> 
> Anyway, it'd be great to generate this flags as well as source file 
> automatically.

Well, the source file would mean some extra construction overhead during 
detection - but generating the flags ought to be possible, by putting the 
test-all entry last and generating a rolling ALL_FLAGS variable via the 
rules above it.

Would you like to write such a patch?

Thanks,

	Ingo
