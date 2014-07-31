Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaGaIST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:18:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093AbaGaISR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:18:17 -0400
Message-ID: <53D9FBC6.9070908@suse.cz>
Date: Thu, 31 Jul 2014 10:18:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: behanw@converseincode.com
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>, bp@alien8.de
Subject: Re: [PATCH v2] kbuild, LLVMLinux: Supress warnings unless W=1-3
References: <53D8ED5D.8070604@suse.cz> <1406780181-7973-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1406780181-7973-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 31.7.2014 06:16, behanw@converseincode.com napsal(a):
> From: Behan Webster <behanw@converseincode.com>
> 
> clang has more warnings enabled by default. Turn them off unless W is set.
> This patch fixes a logic bug where warnings in clang were disabled when W was set.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Cc: mmarek@suse.cz
> Cc: bp@alien8.de
> ---
>  Makefile                   |  1 +
>  scripts/Makefile.extrawarn | 22 ++++++++++++----------
>  2 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index f6a7794..f343e17 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -668,6 +668,7 @@ KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
>  # source of a reference will be _MergedGlobals and not on of the whitelisted names.
>  # See modpost pattern 2
>  KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
> +KBUILD_CFLAGS += $(call cc-option, -fcatch-undefined-behavior)
>  else
>  
>  # This warning generated too much noise in a regular build.
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 6564350..b5b0751 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -26,16 +26,6 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
>  warning-1 += $(call cc-option, -Wunused-but-set-variable)
>  warning-1 += $(call cc-disable-warning, missing-field-initializers)
>  
> -# Clang
> -warning-1 += $(call cc-disable-warning, initializer-overrides)
> -warning-1 += $(call cc-disable-warning, unused-value)
> -warning-1 += $(call cc-disable-warning, format)
> -warning-1 += $(call cc-disable-warning, unknown-warning-option)
> -warning-1 += $(call cc-disable-warning, sign-compare)
> -warning-1 += $(call cc-disable-warning, format-zero-length)
> -warning-1 += $(call cc-disable-warning, uninitialized)
> -warning-1 += $(call cc-option, -fcatch-undefined-behavior)
> -

OK.


>  warning-2 := -Waggregate-return
>  warning-2 += -Wcast-align
>  warning-2 += -Wdisabled-optimization
> @@ -55,6 +45,18 @@ warning-3 += -Wswitch-default
>  warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
>  warning-3 += $(call cc-option, -Wvla)
>  
> +ifeq ($(COMPILER),clang)
> +ifndef $(W)
> +KBUILD_CFLAGS += $(call cc-disable-warning, initializer-overrides)
> +KBUILD_CFLAGS += $(call cc-disable-warning, unused-value)
> +KBUILD_CFLAGS += $(call cc-disable-warning, format)
> +KBUILD_CFLAGS += $(call cc-disable-warning, unknown-warning-option)
> +KBUILD_CFLAGS += $(call cc-disable-warning, sign-compare)
> +KBUILD_CFLAGS += $(call cc-disable-warning, format-zero-length)
> +KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
> +endif
> +endif
> +

Please remove this part, it has no effect. I assume that if it works for
you, these warning are not as annoying so they do not need to be disabled?

Thanks,
Michal
