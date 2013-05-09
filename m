Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab3EIEEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:04:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47160 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3EIEEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:04:34 -0400
Message-ID: <518B204C.4080501@zytor.com>
Date: Wed, 08 May 2013 21:04:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make stat/statfs 64-bit for x86_64 kernels
References: <1368072057-7832-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1368072057-7832-1-git-send-email-vapier@gentoo.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:00 PM, Mike Frysinger wrote:
> diff --git a/arch/x86/include/uapi/asm/statfs.h b/arch/x86/include/uapi/asm/statfs.h
> index 2d0adbf..3cb5744 100644
> --- a/arch/x86/include/uapi/asm/statfs.h
> +++ b/arch/x86/include/uapi/asm/statfs.h
> @@ -8,5 +8,10 @@
>   */
>  #define ARCH_PACK_COMPAT_STATFS64 __attribute__((packed,aligned(4)))
>  
> +/* For x86-64, both the 64bit and x32 ABIs have 64bit fields. */
> +#ifdef __x86_64__
> +#define __statfs_word __u64
> +#endif
> +
>  #include <asm-generic/statfs.h>
>  #endif /* _ASM_X86_STATFS_H */
> 

... or is this what you meant to use?

	-hpa

