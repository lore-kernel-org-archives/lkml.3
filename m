Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbbAIOn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:43:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbbAIOn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:43:57 -0500
Date: Fri, 9 Jan 2015 15:43:32 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lizefan@huawei.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind is
 on
Message-ID: <20150109144332.GB14750@krava.brq.redhat.com>
References: <1419643571-62764-1-git-send-email-wangnan0@huawei.com>
 <20141229075607.GC6081@sejong>
 <54A10D53.2010800@huawei.com>
 <54AC9FC0.7050902@huawei.com>
 <20150107054004.GA849@sejong>
 <20150107083920.GF6243@krava.brq.redhat.com>
 <54AD2672.1010009@huawei.com>
 <CAM9d7chGXX68B54igX5O+3ZEu322cW-Xfoz6Wen8=D8iQpyH6g@mail.gmail.com>
 <54ADDDAF.8060704@huawei.com>
 <20150108050920.GA7268@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108050920.GA7268@sejong>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 02:09:20PM +0900, Namhyung Kim wrote:

SNIP

> > ---
> > diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> > index 67a03a82..1f71a32 100644
> > --- a/tools/perf/Makefile.perf
> > +++ b/tools/perf/Makefile.perf
> > @@ -462,10 +462,12 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
> >  # Benchmark modules
> >  BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
> >  BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
> > -ifeq ($(RAW_ARCH),x86_64)
> > +ifeq ($(ARCH), x86)
> > +ifeq ($(IS_64_BIT), 1)
> >  BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
> >  BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
> >  endif
> > +endif
> >  BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
> >  BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
> >  BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
> 
> Looks good to me!

I'm little confused now.. is this on top of your earlier
patch or this change stands by itself..?

could any of you please resend v2 ? ;-)

thanks,
jirka
