Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3LPQzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:55:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48680 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab3LPQzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:55:52 -0500
Message-ID: <52AF3077.1060001@zytor.com>
Date: Mon, 16 Dec 2013 08:55:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: add user_atomic_cmpxchg_inatomic at uaccess.h
References: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 10:25 PM, Qiaowei Ren wrote:
> +#ifdef CONFIG_X86_64							\
> +	case 8:								\
> +	{								\
> +		asm volatile("\t" ASM_STAC "\n"				\
> +			"1:\t" LOCK_PREFIX "cmpxchgq %4, %2\n"		\
> +			"2:\t" ASM_CLAC "\n"				\
> +			"\t.section .fixup, \"ax\"\n"			\
> +			"3:\tmov     %3, %0\n"				\
> +			"\tjmp     2b\n"				\
> +			"\t.previous\n"					\
> +			_ASM_EXTABLE(1b, 3b)				\
> +			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
> +			: "i" (-EFAULT), "r" (__new), "1" (__old)	\
> +			: "memory"					\
> +		);							\
> +		break;							\
> +	}								\
> +#endif								\

This, of course, doesn't work because this is embedded in a macro.  I
realize I requested it, but you should still have tested it.

Anyway, I'll fix it up.

	-hpa

