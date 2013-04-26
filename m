Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3DZLhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:37:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab3DZLhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:37:45 -0400
Date: Fri, 26 Apr 2013 13:37:09 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/26] perf tools: Move arch check into config/Makefile
Message-ID: <20130426113709.GC1054@krava.brq.redhat.com>
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
 <1366796273-4780-4-git-send-email-jolsa@redhat.com>
 <87vc7b7yyf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc7b7yyf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 06:15:52PM +0900, Namhyung Kim wrote:
> On Wed, 24 Apr 2013 11:37:30 +0200, Jiri Olsa wrote:
> > Moving arch check into config/Makefile.
> >
> [SNIP]
> > +# include config/Makefile by default and rule out
> > +# non-config cases
> > +config := 1
> > +
> > +# standalone clean
> > +ifeq ($(MAKECMDGOALS),clean)
> > +  config := 0
> >  endif
> > -ifeq ($(ARCH),x86_64)
> > -	override ARCH := x86
> > -	IS_X86_64 := 0
> > -	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
> > -		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
> > -	endif
> > -	ifeq (${IS_X86_64}, 1)
> > -		RAW_ARCH := x86_64
> > -		ARCH_CFLAGS := -DARCH_X86_64
> > -		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
> > -	endif
> > -	NO_PERF_REGS := 0
> > -	LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
> > +
> > +# tags cscope
> > +ifneq ($(filter tags cscope,$(MAKECMDGOALS)),)
> > +  config := 0
> > +endif
> 
> Good idea!
> 
> How about consolidating them like:
> 
>   NON_CONFIG_TARGETS := clean TAGS tags cscope help
>   
>   ifeq ($(filter-out $(NON_CONFIG_TARGETS),$(MAKECMDGOALS)),)
>     config := 0
>   endif

nice, I'll do that

thanks,
jirka
