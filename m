Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181AbaD3VWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:22:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54437 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308AbaD3VWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:22:41 -0400
Message-ID: <5361698B.4060607@zytor.com>
Date: Wed, 30 Apr 2014 14:22:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: Re: [PATCH] word-at-a-time: avoid undefined behaviour in zero_bytemask
 macro
References: <1398271972-15177-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1398271972-15177-1-git-send-email-will.deacon@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 09:52 AM, Will Deacon wrote:
> 
> diff --git a/include/asm-generic/word-at-a-time.h b/include/asm-generic/word-at-a-time.h
> index d3909effd725..d96deb443f18 100644
> --- a/include/asm-generic/word-at-a-time.h
> +++ b/include/asm-generic/word-at-a-time.h
> @@ -50,11 +50,7 @@ static inline bool has_zero(unsigned long val, unsigned long *data, const struct
>  }
>  
>  #ifndef zero_bytemask
> -#ifdef CONFIG_64BIT
> -#define zero_bytemask(mask)	(~0ul << fls64(mask))
> -#else
> -#define zero_bytemask(mask)	(~0ul << fls(mask))
> -#endif /* CONFIG_64BIT */
> -#endif /* zero_bytemask */
> +#define zero_bytemask(mask) (~0ul << __fls(mask) << 1)
> +#endif
>  
>  #endif /* _ASM_WORD_AT_A_TIME_H */
> 

Why not:

#define zero_bytemask(mask) (~1ul << __fls(mask))
