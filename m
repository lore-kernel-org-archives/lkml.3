Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3LJKOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab3LJKOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:14:15 -0500
Date: Tue, 10 Dec 2013 11:13:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Arnaldo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>, Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 2/2] perf: unwinding: use the per-feature check flags
Message-ID: <20131210101350.GC8108@krava.brq.redhat.com>
References: <1386411461-21510-1-git-send-email-jean.pihet@linaro.org>
 <1386411461-21510-3-git-send-email-jean.pihet@linaro.org>
 <20131209171719.GA16631@krava.brq.redhat.com>
 <CAFrcx1khWGXJOyyqOBedyZsmLWYdhmkGsn0FhNt6hwCYhf5qfA@mail.gmail.com>
 <20131210095723.GB2352@krava.brq.redhat.com>
 <CAFrcx1kKmTf=6DjAbn8F=--KaijotSqo8_dkRFpgo5J+q8Vfeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1kKmTf=6DjAbn8F=--KaijotSqo8_dkRFpgo5J+q8Vfeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:05:04AM +0100, Jean Pihet wrote:
> Hi Jiri,
> 
> On 10 December 2013 10:57, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Mon, Dec 09, 2013 at 07:02:02PM +0100, Jean Pihet wrote:
> >> Hi Jiri,
> >>
> >> On 9 December 2013 18:17, Jiri Olsa <jolsa@redhat.com> wrote:
> >> > On Sat, Dec 07, 2013 at 11:17:41AM +0100, Jean Pihet wrote:
> >> >> Use the per-feature check flags for the unwinding feature in order
> >> >> to correctly compile the libunwind and libunwind-debug-frame feature
> >> >> checks.
> >> >>
> >> >> Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR set
> >> >> in 'make -C tools/perf'
> >> >>
> >> >> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> >> >> Cc: Jiri Olsa <jolsa@redhat.com>
> >> >
> >> > SNIP
> >> >
> >> >> +BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $@.c $(LDFLAGS)
> >> >>
> >> >>  ###############################
> >> >>
> >> >>  test-all:
> >> >> -     $(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
> >> >> +     $(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
> >> >
> >> > hum, the test-all build command should have every possible flags we use, right?
> >> > including LIBUNWIND_CFLAGS, LIBUNWIND_LDFLAGS
> >> Oh yes you are right. I am overlooked the test-all feature (which
> >> never builds on my modest embedded systems).
> >> $(LIBUNWIND_LIBS) should be replaced by $(LIBUNWIND_CFLAGS)
> >> $(LIBUNWIND_LDFLAGS), is that a reasonable approach?
> >
> > hum, I'm just dealing with same issue for new libdw feature.. ;-)
> >
> > I was wondering we could just setup:
> >   FEATURE_CHECK_CFLAGS-all
> >   FEATURE_CHECK_LDFLAGS-all
> >
> > automatically from all defined FEATURE_CHECK_(C|LD)FLAGS-*
> > just a thought.. haven't tried it yet
> Yes that is the idea. The per-feature flags are designed for that
> purpose. For now I have the fix for libunwind only, cf. here below.
> All features should use the flags. There are complex cases though (e.g
> perl flags in config/Makefile andconfig/feature-checks)...
> 
> My plan is to submit the ix for libunwind first and if ok care about
> the other features. Is that OK?

sounds good, thanks

jirka
