Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaFYIMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:12:36 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:44877 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaFYIMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:12:34 -0400
MIME-Version: 1.0
In-Reply-To: <1403666205-25346-1-git-send-email-msalter@redhat.com>
References: <1403666205-25346-1-git-send-email-msalter@redhat.com>
Date: Wed, 25 Jun 2014 10:12:33 +0200
Message-ID: <CAFrcx1n4Txz0a59omx3OKPQQR+AYV2NgNuJ16O01z_7PtGcJpw@mail.gmail.com>
Subject: Re: [PATCH] perf: fix arm64 build error
From: Jean Pihet <jean.pihet@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 25 June 2014 05:16, Mark Salter <msalter@redhat.com> wrote:
> I'm seeing the following build error on arm64:
>
>   In file included from util/event.c:3:0:
>   util/event.h:95:17: error: 'PERF_REGS_MAX' undeclared here (not in a function)
>     u64 cache_regs[PERF_REGS_MAX];
>                  ^
>
> This patch adds a PEFF_REGS_MAX definition for arm64.
s/PEFF_REGS_MAX/PERF_REGS_MAX

>
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: Jean Pihet <jean.pihet@linaro.org>

Thanks!

Note: Do you have any performance figure with and without the caching
code in perf?

Jean

> ---
>  tools/perf/arch/arm64/include/perf_regs.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
> index e9441b9..1d3f39c 100644
> --- a/tools/perf/arch/arm64/include/perf_regs.h
> +++ b/tools/perf/arch/arm64/include/perf_regs.h
> @@ -6,6 +6,8 @@
>  #include <asm/perf_regs.h>
>
>  #define PERF_REGS_MASK ((1ULL << PERF_REG_ARM64_MAX) - 1)
> +#define PERF_REGS_MAX  PERF_REG_ARM64_MAX
> +
>  #define PERF_REG_IP    PERF_REG_ARM64_PC
>  #define PERF_REG_SP    PERF_REG_ARM64_SP
>
> --
> 1.9.0
>
