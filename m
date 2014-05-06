Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaEFUNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:13:31 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:49543 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaEFUN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:13:29 -0400
Date: Tue, 6 May 2014 16:13:24 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] arm: put_user: fix possible data corruption in
 put_user
In-Reply-To: <1399360312-13843-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.LFD.2.11.1405061610450.980@knanqh.ubzr>
References: <alpine.LFD.2.11.1405050950410.980@knanqh.ubzr> <1399360312-13843-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Andrey Ryabinin wrote:

> According to arm procedure call standart r2 register is call-cloberred.
> So after the result of x expression was put into r2 any following
> function call in p may overwrite r2. To fix this, the result of p
> expression must be saved to the temporary variable before the
> assigment x expression to __r2.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> Cc: stable@vger.kernel.org

Please push this patch into Russell's patch system.

Thanks.

> ---
> Since v1:
>  - tmp_p variable renamed to __tmp_p
>  - added Reviewed-by tag
>  - added Cc: stable@vger.kernel.org
> 
>  arch/arm/include/asm/uaccess.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
> index 12c3a5d..75d9579 100644
> --- a/arch/arm/include/asm/uaccess.h
> +++ b/arch/arm/include/asm/uaccess.h
> @@ -171,8 +171,9 @@ extern int __put_user_8(void *, unsigned long long);
>  #define __put_user_check(x,p)							\
>  	({								\
>  		unsigned long __limit = current_thread_info()->addr_limit - 1; \
> +		const typeof(*(p)) __user *__tmp_p = (p);		\
>  		register const typeof(*(p)) __r2 asm("r2") = (x);	\
> -		register const typeof(*(p)) __user *__p asm("r0") = (p);\
> +		register const typeof(*(p)) __user *__p asm("r0") = __tmp_p; \
>  		register unsigned long __l asm("r1") = __limit;		\
>  		register int __e asm("r0");				\
>  		switch (sizeof(*(__p))) {				\
> -- 
> 1.8.5.5
> 
