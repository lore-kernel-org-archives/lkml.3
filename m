Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3LISQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:16:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab3LISP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:15:59 -0500
Date: Mon, 9 Dec 2013 19:15:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Arnaldo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>, Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 2/2] perf: unwinding: use the per-feature check flags
Message-ID: <20131209181547.GB16631@krava.brq.redhat.com>
References: <1386411461-21510-1-git-send-email-jean.pihet@linaro.org>
 <1386411461-21510-3-git-send-email-jean.pihet@linaro.org>
 <20131209171719.GA16631@krava.brq.redhat.com>
 <CAFrcx1khWGXJOyyqOBedyZsmLWYdhmkGsn0FhNt6hwCYhf5qfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1khWGXJOyyqOBedyZsmLWYdhmkGsn0FhNt6hwCYhf5qfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 07:02:02PM +0100, Jean Pihet wrote:
> Hi Jiri,
> 
> On 9 December 2013 18:17, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Sat, Dec 07, 2013 at 11:17:41AM +0100, Jean Pihet wrote:
> >> Use the per-feature check flags for the unwinding feature in order
> >> to correctly compile the libunwind and libunwind-debug-frame feature
> >> checks.
> >>
> >> Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR set
> >> in 'make -C tools/perf'
> >>
> >> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> >> Cc: Jiri Olsa <jolsa@redhat.com>
> >
> > SNIP
> >
> >> +BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $@.c $(LDFLAGS)
> >>
> >>  ###############################
> >>
> >>  test-all:
> >> -     $(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
> >> +     $(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
> >
> > hum, the test-all build command should have every possible flags we use, right?
> > including LIBUNWIND_CFLAGS, LIBUNWIND_LDFLAGS
> Oh yes you are right. I am overlooked the test-all feature (which
> never builds on my modest embedded systems).
> $(LIBUNWIND_LIBS) should be replaced by $(LIBUNWIND_CFLAGS)
> $(LIBUNWIND_LDFLAGS), is that a reasonable approach?
> 
> >
> > also, this patch no longer applies on acme's perf/core
> I am using a recent mainline (3.12-rc2).
> 
> Let me correct the patch on acme's perf/core. Is that OK?

yep, thats the best practise 

jirka
