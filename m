Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaFDBux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:50:53 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37585 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaFDBuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:50:51 -0400
Message-ID: <538E7B77.6010700@gmail.com>
Date: Tue, 03 Jun 2014 19:50:47 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org
CC: jolsa@redhat.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: Re: [PATCH 05/32] perf kbuild: fix recursive invocation of config/features-checks
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com> <1401833185-10347-6-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1401833185-10347-6-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

you are missing a commit message as to why the below change is needed. 
What happens without this patch. What happens with this patch.

David

On 6/3/14, 4:05 PM, Alexis Berlemont wrote:
> ---
>   tools/perf/Makefile.kbuild | 2 +-
>   tools/perf/config/Makefile | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
> index 1e3621f..b2d0d08 100644
> --- a/tools/perf/Makefile.kbuild
> +++ b/tools/perf/Makefile.kbuild
> @@ -90,7 +90,7 @@ VPATH += $(src-perf)
>
>   export src-perf obj-perf
>
> -OUTPUT := $(obj-perf)
> +OUTPUT := $(obj-perf)/
>
>   export OUTPUT
>
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 78ee62d..1760f57 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -135,7 +135,7 @@ endif
>
>   feature_check = $(eval $(feature_check_code))
>   define feature_check_code
> -  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C config/feature-checks test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
> +  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C $(src-perf)/config/feature-checks test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
>   endef
>
>   feature_set = $(eval $(feature_set_code))
> @@ -234,7 +234,7 @@ ifeq ($(feature-all), 1)
>     #
>     $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
>   else
> -  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(addsuffix .bin,$(CORE_FEATURE_TESTS)) >/dev/null 2>&1)
> +  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C $(src-perf)/config/feature-checks $(addsuffix .bin,$(CORE_FEATURE_TESTS)) >/dev/null 2>&1)
>     $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
>   endif
>
>

