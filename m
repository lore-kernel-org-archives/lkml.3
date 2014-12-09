Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaLIKO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:14:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbaLIKOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:14:54 -0500
Date: Tue, 9 Dec 2014 11:14:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/8] perf tools: Add feature check for libbabeltrace
Message-ID: <20141209101416.GB2516@krava.brq.redhat.com>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
 <1417623842-14331-2-git-send-email-jolsa@kernel.org>
 <CAM9d7cixHgGqiLu0c8zrbEU6aLNdvhwC0vne4zcd8OZjQkCV1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cixHgGqiLu0c8zrbEU6aLNdvhwC0vne4zcd8OZjQkCV1Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 05:07:23PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Thu, Dec 4, 2014 at 1:23 AM, Jiri Olsa <jolsa@kernel.org> wrote:
> > +ifndef NO_LIBBABELTRACE
> > +  # for linking with debug library, run like:
> > +  # make DEBUG=1 LIBBABELTRACE_DIR=/opt/libdw/
> 
> s/libdw/libbabeltrace/

ouch.. copy&paste crap ;-)

> 
> 
> > +  ifdef LIBBABELTRACE_DIR
> > +    LIBBABELTRACE_CFLAGS  := -I$(LIBBABELTRACE_DIR)/include
> > +    LIBBABELTRACE_LDFLAGS := -L$(LIBBABELTRACE_DIR)/lib
> > +  endif
> > +  FEATURE_CHECK_CFLAGS-libbabeltrace := $(LIBBABELTRACE_CFLAGS)
> > +  FEATURE_CHECK_LDFLAGS-libbabeltrace := $(LIBBABELTRACE_LDFLAGS) -lbabeltrace-ctf
> > +endif
> > +
> >  # include ARCH specific config
> >  -include $(src-perf)/arch/$(ARCH)/Makefile
> >
> > @@ -201,6 +212,7 @@ CORE_FEATURE_TESTS =                        \
> >         stackprotector-all              \
> >         timerfd                         \
> >         libdw-dwarf-unwind              \
> > +       libbabeltrace                   \
> >         zlib
> >
> >  LIB_FEATURE_TESTS =                    \
> > @@ -216,6 +228,7 @@ LIB_FEATURE_TESTS =                 \
> >         libslang                        \
> >         libunwind                       \
> >         libdw-dwarf-unwind              \
> > +       libbabeltrace                   \
> >         zlib
> >
> >  VF_FEATURE_TESTS =                     \
> > @@ -661,6 +674,17 @@ else
> >    NO_PERF_READ_VDSOX32 := 1
> >  endif
> >
> > +ifndef NO_LIBBABELTRACE
> > +  ifeq ($(feature-libbabeltrace), 0)
> > +    msg := $(warning No libbabeltrace found, disables 'perf data' CTF format support, please install libbabeltrace-devel/libbabeltrace-dev);
> 
> It seems that Ubuntu has libbabeltrace-ctf-dev package.

ok

thanks,
jirka
