Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaFVIJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:09:46 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:55795 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaFVIJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:09:41 -0400
MIME-Version: 1.0
In-Reply-To: <53A66000.4010208@gmail.com>
References: <53A66000.4010208@gmail.com>
Date: Sun, 22 Jun 2014 16:09:40 +0800
Message-ID: <CAF0htA7jReHGSL+K_rh9CMN_Wsyy=nL-TsN3T2L+FQUpAEXyrg@mail.gmail.com>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
From: Lennox Wu <lennox.wu@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,
Do you find other modules except device modules cause issues of compiling?
The applications of Score are limited. Acutally, some errors never occur
in the limited applications, for example, the conbination consists of
Score and the timer of SuperH. I'm not sure we should handle this kind
of error.
If the rule is that we should make sure "all" modules can be compiled
with Score, we will do it.
However, we still thanks for your check.

Best,
Lennox

2014-06-22 12:48 GMT+08:00 Chen Gang <gang.chen.5i5j@gmail.com>:
> 'COUNTER' and other same kind macros are too common to use, and easy to
> get conflict with other modules. So add prefix for them.
>
> The related warning (allmodconfig with score):
>
>     CC [M]  drivers/md/raid1.o
>   In file included from drivers/md/raid1.c:42:0:
>   drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
>    #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
>    ^
>   In file included from ./arch/score/include/asm/ptrace.h:4:0,
>                    from include/linux/sched.h:31,
>                    from include/linux/blkdev.h:4,
>                    from drivers/md/raid1.c:36:
>   ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the location of the previous definition
>    #define COUNTER  38
>
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/score/include/uapi/asm/ptrace.h | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/score/include/uapi/asm/ptrace.h b/arch/score/include/uapi/asm/ptrace.h
> index f59771a..7a0ead9 100644
> --- a/arch/score/include/uapi/asm/ptrace.h
> +++ b/arch/score/include/uapi/asm/ptrace.h
> @@ -4,16 +4,16 @@
>  #define PTRACE_GETREGS         12
>  #define PTRACE_SETREGS         13
>
> -#define PC             32
> -#define CONDITION      33
> -#define ECR            34
> -#define EMA            35
> -#define CEH            36
> -#define CEL            37
> -#define COUNTER                38
> -#define LDCR           39
> -#define STCR           40
> -#define PSR            41
> +#define SCORE_PC               32
> +#define SCORE_CONDITION                33
> +#define SCORE_ECR              34
> +#define SCORE_EMA              35
> +#define SCORE_CEH              36
> +#define SOCRE_CEL              37
> +#define SCORE_COUNTER          38
> +#define SCORE_LDCR             39
> +#define SCORE_STCR             40
> +#define SCORE_PSR              41
>
>  #define SINGLESTEP16_INSN      0x7006
>  #define SINGLESTEP32_INSN      0x840C8000
> --
> 1.9.2.459.g68773ac
