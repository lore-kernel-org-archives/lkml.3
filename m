Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3JGVBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:01:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab3JGVA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:00:59 -0400
Date: Mon, 7 Oct 2013 23:00:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 19/50] tools/perf/build: Split out feature check:
 'libaudit'
Message-ID: <20131007210048.GA2900@krava.redhat.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-20-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381147003-2574-20-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:56:12PM +0200, Ingo Molnar wrote:
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Link: http://lkml.kernel.org/n/tip-orhejqtjao3vf4wxwBUdzhaz@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  tools/perf/config/Makefile                       | 6 +++---
>  tools/perf/config/feature-checks/Makefile        | 4 ++++
>  tools/perf/config/feature-checks/test-libaudit.c | 7 +++++++
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 890f264..e82e0b8 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -114,6 +114,7 @@ FEATURE_TESTS =				\
>  	libelf-mmap			\
>  	libelf-getphdrnum		\
>  	libunwind			\
> +	libaudit			\
>  	libnuma
>  
>  $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
> @@ -240,7 +241,7 @@ ifneq ($(ARCH),x86)
>  endif
>  
>  ifndef NO_LIBUNWIND
> -  ifeq ($(feature-libunwind), 1)
> +  ifneq ($(feature-libunwind), 1)
>      msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
>      NO_LIBUNWIND := 1
>    endif

nit, this change belongs to previous patch

jirka
