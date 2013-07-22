Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3GVPCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:02:52 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:37091 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3GVPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:02:50 -0400
Date: Mon, 22 Jul 2013 12:02:42 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Oliver Yang <yangoliver@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] Fix build failures of python/perf.so.
Message-ID: <20130722150242.GB2157@ghostprotocols.net>
References: <1374493559-11139-1-git-send-email-yangoliver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374493559-11139-1-git-send-email-yangoliver@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 22, 2013 at 07:45:59PM +0800, Oliver Yang escreveu:
> If gcc and python are not under the standard path, it could cause
> the build failure of perf.so.

How can just adding the prefix to the compiler like that fix something?

Looking at the references to CROSS_COMPILE in tools/perf/Makefile:

-----------------------------------

# Define CROSS_COMPILE as prefix name of compiler if you want
# cross-builds.

<SNIP>

CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar

-----------------------------------

Can you provide the make command line you're using that makes it work
for you with this patch?

Thanks,

- Arnaldo
 
> Signed-off-by: Oliver Yang <yangoliver@gmail.com>
> ---
>  tools/perf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 641fccd..9f88f6f 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -151,7 +151,7 @@ PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
>  PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBLK)
>  
>  $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
> -	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
> +	$(QUIET_GEN)CFLAGS='$(CROSS_COMPILE)' '$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
>  	  --quiet build_ext; \
>  	mkdir -p $(OUTPUT)python && \
>  	cp $(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/
> -- 
> 1.8.1.2
