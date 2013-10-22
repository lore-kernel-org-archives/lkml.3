Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3JVHkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:40:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:5596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab3JVHkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:40:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422760535"
Message-ID: <52662BDC.5040101@intel.com>
Date: Tue, 22 Oct 2013 10:40:12 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 13/19] perf tools: Fix libunwind build and feature detection
 for 32-bit build
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-14-git-send-email-adrian.hunter@intel.com> <20131020204346.GD12044@krava> <20131021141428.GB2245@ghostprotocols.net>
In-Reply-To: <20131021141428.GB2245@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/13 17:14, Arnaldo Carvalho de Melo wrote:
> Em Sun, Oct 20, 2013 at 10:43:46PM +0200, Jiri Olsa escreveu:
>> On Fri, Oct 18, 2013 at 03:29:10PM +0300, Adrian Hunter wrote:
>>> Use -lunwind-x86 instead of -lunwind-x86_64 for 32-bit build.
> 
>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
>> Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> Doesn't apply because it depends on a patch in this series that I made a
> question about, the "CFLAGS=-g ... one, but then can we avoid touching
> this feature_check_code line with feature specific stuff, i.e. can't we
> just touch LDFLAGS or CFLAGS?

Because LDFLAGS and CFLAGS are used for all tests, all tests would
fail if any feature libraries were not present.

Also because 'make' invokes 'make' via a shell, it is not possible
to export variables.

That just leaves the command line as far as I can see.

> 
> - Arnaldo
> 
> --- tools/perf/config/Makefile
> +++ tools/perf/config/Makefile
> @@ -94,7 +96,7 @@
>  
>  feature_check = $(eval $(feature_check_code))
>  define feature_check_code
> -  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(CFLAGS)" LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
> +  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(CFLAGS)" LDFLAGS=$(LDFLAGS) LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
>  endef
>  
>  feature_set = $(eval $(feature_set_code))
> 
> 

