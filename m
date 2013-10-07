Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3JGWDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:03:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab3JGWDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:03:18 -0400
Date: Mon, 7 Oct 2013 23:59:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 31/50] tools/perf/build: Speed up auto-detection of
 features by adding a 'test-all' target
Message-ID: <20131007215955.GE2900@krava.redhat.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-32-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381147003-2574-32-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:56:24PM +0200, Ingo Molnar wrote:

SNIP

> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index c65bdac..b031669 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -32,6 +32,9 @@ BUILD = $(CC) -o $(OUTPUT)$@ $@.c
>  
>  ###############################
>  
> +test-all:
> +	$(BUILD) -Werror -fstack-protector -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
> +

missing -fstack-protector-all ?

jirka
