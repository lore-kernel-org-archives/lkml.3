Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3JGV5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab3JGV5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:57:13 -0400
Date: Mon, 7 Oct 2013 23:57:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 36/50] tools/perf/build: Speed up auto-detection
Message-ID: <20131007215704.GD2900@krava.redhat.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-37-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381147003-2574-37-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:56:29PM +0200, Ingo Molnar wrote:

SNIP

> -FEATURE_TESTS =				\
> -	hello				\
> -	stackprotector-all		\
> -	stackprotector			\
> -	volatile-register-var		\
> +#
> +# Note that this is not a complete list of all feature tests, just
> +# those that are typically built on a fully configured system.
> +#
> +# [ Feature tests not mentioned here have to be built explicitly in
> +#   the rule that uses them - an example for that is the 'bionic'
> +#   feature check. ]
> +#
> +CORE_FEATURE_TESTS =			\
> +	backtrace			\
> +	dwarf				\
>  	fortify-source			\
> -	bionic				\
> -	libelf				\
>  	glibc				\
> -	dwarf				\
> -	libelf-mmap			\
> -	libelf-getphdrnum		\
> -	libunwind			\
> -	libaudit			\
> -	libslang			\
>  	gtk2				\
>  	gtk2-infobar			\
> +	libaudit			\
> +	libbfd				\
> +	libelf				\
> +	libelf-getphdrnum		\
> +	libelf-mmap			\
> +	libnuma				\
>  	libperl				\
>  	libpython			\
>  	libpython-version		\
> -	libbfd				\
> +	libslang			\
> +	libunwind			\
>  	on-exit				\
> -	backtrace			\
> -	libnuma
> +	stackprotector-all		\

missing stackprotector?

I guess that various gcc version could support either
of them or both.. so we need to check for both

looks like -fstack-protector-all overloads -fstack-protector
but no harm to have them both added probably ;-)

jirka
