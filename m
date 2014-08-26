Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbaHZNQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:16:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847AbaHZNQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:16:22 -0400
Date: Tue, 26 Aug 2014 10:18:04 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: sukadev@linux.vnet.ibm.com, mpe@ellerman.id.au, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf powerpc: Fix build issue when DWARF support is
 disabled
Message-ID: <20140826131804.GA3070@redhat.com>
References: <20140825182307.49774a04@kryten>
 <20140825182506.2be6512d@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825182506.2be6512d@kryten>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 25, 2014 at 06:25:06PM +1000, Anton Blanchard escreveu:
> The powerpc skip callchain code uses DWARF, so we must disable it if
> DWARF is disabled.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Thanks, applied.

- Arnaldo

> 
> Index: b/tools/perf/arch/powerpc/Makefile
> ===================================================================
> --- a/tools/perf/arch/powerpc/Makefile
> +++ b/tools/perf/arch/powerpc/Makefile
> @@ -1,6 +1,6 @@
>  ifndef NO_DWARF
>  PERF_HAVE_DWARF_REGS := 1
>  LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
> +LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
>  endif
>  LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
> -LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
> Index: b/tools/perf/config/Makefile
> ===================================================================
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -48,10 +48,6 @@ ifneq ($(ARCH),$(filter $(ARCH),x86 arm)
>    NO_LIBDW_DWARF_UNWIND := 1
>  endif
>  
> -ifeq ($(ARCH),powerpc)
> -  CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
> -endif
> -
>  ifeq ($(LIBUNWIND_LIBS),)
>    NO_LIBUNWIND := 1
>  else
> @@ -355,6 +351,12 @@ ifndef NO_LIBELF
>    endif # NO_DWARF
>  endif # NO_LIBELF
>  
> +ifeq ($(ARCH),powerpc)
> +  ifndef NO_DWARF
> +    CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
> +  endif
> +endif
> +
>  ifndef NO_LIBUNWIND
>    ifneq ($(feature-libunwind), 1)
>      msg := $(warning No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR);
