Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3JJG4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:56:13 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33288 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3JJG4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:56:12 -0400
Date: Thu, 10 Oct 2013 08:56:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH 15/52] tools/perf/build: Split out feature check:
 'libelf-mmap'
Message-ID: <20131010065609.GE10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-16-git-send-email-mingo@kernel.org>
 <8761t5k6mf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761t5k6mf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue,  8 Oct 2013 12:10:45 +0200, Ingo Molnar wrote:
> > @@ -202,7 +203,7 @@ ifndef NO_LIBELF
> >    CFLAGS += -DHAVE_LIBELF_SUPPORT
> >    FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
> >  
> > -  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
> > +  ifeq ($(feature-libelf-mmap), 1)
> >      CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
> >    endif
> >  
> > @@ -227,8 +228,7 @@ endif # NO_LIBELF
> >  
> >  ifndef NO_LIBELF
> >    CFLAGS += -DHAVE_LIBELF_SUPPORT
> > -  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
> > -  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
> > +  ifeq ($(feature-libelf-mmap), 1)
> >      CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
> >    endif # try-cc
> >  endif # NO_LIBELF
> 
> As Ulrich Drepper reported, it seems that this hunk is duplicate.

This was pre-existing, but indeed it's an unnecessary duplication. I'll 
send a patch in a separate mail.

Thanks,

	Ingo
