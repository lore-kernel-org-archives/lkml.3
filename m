Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3KZR4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:56:53 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:52079 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab3KZR4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:56:51 -0500
Date: Tue, 26 Nov 2013 18:56:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo <acme@ghostprotocols.net>, patches@linaro.org
Subject: Re: [PATCH 1/2] perf: add per-feature check flags
Message-ID: <20131126175647.GA9958@gmail.com>
References: <1385045539-24537-1-git-send-email-jean.pihet@linaro.org>
 <1385045539-24537-2-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385045539-24537-2-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Pihet <jean.pihet@linaro.org> wrote:

> Add CFLAGS and LDFLAGS for each feature to be checked. This allows
> to pass flags and parameters to the feature checks compilation.
> Also simplifies the feature check makefile, to come in a subsequent patch.
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> ---
>  tools/perf/config/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index f7d11a8..c551495 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -102,7 +102,7 @@ endif
>  
>  feature_check = $(eval $(feature_check_code))
>  define feature_check_code
> -  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS="$(LDFLAGS)" LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
> +  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
>  endef

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
