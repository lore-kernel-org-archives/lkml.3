Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaFXOrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:47:24 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54708 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaFXOrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:47:22 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A98F6F.4080503@roeck-us.net>
Date: Tue, 24 Jun 2014 07:47:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, David Rientjes <rientjes@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A9783C.7050206@gmail.com>
In-Reply-To: <53A9783C.7050206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 06:08 AM, Chen Gang wrote:
> 'COUNTER' and other same kind macros are too common to use, and easy to
> get conflict with other modules. So add prefix for them.
>
> And it is UAPI, so only change it within linux kernel.
>
> The related warning (allmodconfig with score):
>
>      CC [M]  drivers/md/raid1.o
>    In file included from drivers/md/raid1.c:42:0:
>    drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
>     #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
>     ^
>    In file included from ./arch/score/include/asm/ptrace.h:4:0,
>                     from include/linux/sched.h:31,
>                     from include/linux/blkdev.h:4,
>                     from drivers/md/raid1.c:36:
>    ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the location of the previous definition
>     #define COUNTER  38
>
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>   arch/score/include/uapi/asm/ptrace.h | 33 +++++++++++++++++++++++----------
>   1 file changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/arch/score/include/uapi/asm/ptrace.h b/arch/score/include/uapi/asm/ptrace.h
> index f59771a..56e2de0 100644
> --- a/arch/score/include/uapi/asm/ptrace.h
> +++ b/arch/score/include/uapi/asm/ptrace.h
> @@ -4,16 +4,29 @@
>   #define PTRACE_GETREGS		12
>   #define PTRACE_SETREGS		13
>
> -#define PC		32
> -#define CONDITION	33
> -#define ECR		34
> -#define EMA		35
> -#define CEH		36
> -#define CEL		37
> -#define COUNTER		38
> -#define LDCR		39
> -#define STCR		40
> -#define PSR		41
> +#if !defined(__KERNEL__) || !defined(__linux__)
> +#define PC			32
> +#define CONDITION		33
> +#define ECR			34
> +#define EMA			35
> +#define CEH			36
> +#define CEL			37
> +#define COUNTER			38
> +#define LDCR			39
> +#define STCR			40
> +#define PSR			41
> +#else
> +#define SCORE_PC		32
> +#define SCORE_CONDITION		33
> +#define SCORE_ECR		34
> +#define SCORE_EMA		35
> +#define SCORE_CEH		36
> +#define SCORE_CEL		37
> +#define SCORE_COUNTER		38
> +#define SCORE_LDCR		39
> +#define SCORE_STCR		40
> +#define SCORE_PSR		41
> +#endif
>
>   #define SINGLESTEP16_INSN	0x7006
>   #define SINGLESTEP32_INSN	0x840C8000
>
That looks weird ... not sure if that is a good solution either.

Are those defines actually used anywhere ? They don't seem to be used in the kernel.

Side note - an 'a' got missing in your headline.
And I'd suggest to abbreviate it to something like
	score/uapi: ptrace.h:

Thanks,
Guenter

