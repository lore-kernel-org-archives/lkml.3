Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaCSSxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:53:54 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45076 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaCSSxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140319065205.060180266@infradead.org>
References: <20140319064729.660482086@infradead.org>
	<20140319065205.060180266@infradead.org>
Date: Thu, 20 Mar 2014 02:53:50 +0800
Message-ID: <CAF0htA44Skgit5kE6g1zFQZr2byQeD_Ek5EmvQzQ6hT7nYb4qg@mail.gmail.com>
Subject: Re: [PATCH 24/31] arch,score: Convert smp_mb__*
From: Lennox Wu <lennox.wu@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's fine to S+core
Thanks :)

Acked-by: Lennox Wu<lennox.wu@gmail.com>

2014-03-19 14:47 GMT+08:00 Peter Zijlstra <peterz@infradead.org>:
> score fully relies on asm-generic/barrier.h, so it can use its default
> implementation.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/score/include/asm/bitops.h |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> --- a/arch/score/include/asm/bitops.h
> +++ b/arch/score/include/asm/bitops.h
> @@ -2,12 +2,7 @@
>  #define _ASM_SCORE_BITOPS_H
>
>  #include <asm/byteorder.h> /* swab32 */
> -
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()     barrier()
> -#define smp_mb__after_clear_bit()      barrier()
> +#include <asm/barrier.h>
>
>  #include <asm-generic/bitops.h>
>  #include <asm-generic/bitops/__fls.h>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
