Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3JGV1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3JGV1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:27:40 -0400
Date: Mon, 7 Oct 2013 23:27:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 31/50] tools/perf/build: Speed up auto-detection of
 features by adding a 'test-all' target
Message-ID: <20131007212731.GC2900@krava.redhat.com>
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

> +
> +#
> +# Print the result of the feature test:
> +#
> +define feature_print_code
> +  ifeq ($(feature-$(1)), 1)
> +    MSG := $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
> +  else
> +    MSG := $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
> +  endif
> +  $(info $(MSG))
> +endef
> +
> +$(foreach feat,$(FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
> +
> +# newline at the end of the feature printouts:
> +$(info )
>  
> -ifeq ($(stackprotector-all), 1)
> +ifeq ($(feature-stackprotector-all), 1)
>    CFLAGS += -fstack-protector-all
>  endif

nit, belongs to:
  tools/perf/build: Split out feature check: 'stackprotector-all'

jirka
