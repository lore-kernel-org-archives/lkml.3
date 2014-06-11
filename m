Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaFKNiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:38:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54207 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaFKNix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:38:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140611092330.7930eff2@gandalf.local.home>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-2-git-send-email-takahiro.akashi@linaro.org>
	<CAMuHMdWs9i4pBNbn-RTpv_-K5W7YGED=KtEtFSci=7YHdNKpfw@mail.gmail.com>
	<20140611092330.7930eff2@gandalf.local.home>
Date: Wed, 11 Jun 2014 15:38:49 +0200
X-Google-Sender-Auth: AMGVoCdtGEUyQolbjo7A4hnvLO8
Message-ID: <CAMuHMdWm+hpumykRG2FudDPYSVODv1WoU6_tPv5D3HCPDQtDSw@mail.gmail.com>
Subject: Re: [PATCH] arm/ftrace: Fix function_return_addr() to function_return_address()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tim Bird <tim.bird@sonymobile.com>, gkulkarni@caviumnetworks.com,
        Deepak Saxena <dsaxena@linaro.org>, arndb@arndb.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, Jun 11, 2014 at 3:23 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> The clean up of CALLER_ADDR*() functions required the archs to either
> use the default __builtin_return_address(X) (where X > 0) or override
> it with something the arch can use. To override it, the arch would
> define function_return_address(x).

ftrace_return_address(x)

> The arm architecture requires this to be redefined but instead of
> defining function_return_address(x) it defined function_return_addr(x).

ftrace_return_address(x) ... ftrace_return_address(x)

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Nevertheless, your patch kills the warnings. Thanks!

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ----
> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> index eb577f4..39eb16b 100644
> --- a/arch/arm/include/asm/ftrace.h
> +++ b/arch/arm/include/asm/ftrace.h
> @@ -52,7 +52,7 @@ extern inline void *return_address(unsigned int level)
>
>  #endif
>
> -#define ftrace_return_addr(n) return_address(n)
> +#define ftrace_return_address(n) return_address(n)
>
>  #endif /* ifndef __ASSEMBLY__ */

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
