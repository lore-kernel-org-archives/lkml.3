Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3JAUr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:47:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54893 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab3JAUr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:47:27 -0400
Message-ID: <524B34B9.4020504@zytor.com>
Date: Tue, 01 Oct 2013 13:46:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        kernel-hardening@lists.openwall.com, adurbin@google.com,
        Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com,
        Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH 4/7] x86, kaslr: select random base offset
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <1380656245-29975-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1380656245-29975-5-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 12:37 PM, Kees Cook wrote:
> +
> +#include <asm/archrandom.h>
> +static inline int rdrand(unsigned long *v)
> +{
> +	int ok;
> +	asm volatile("1: " RDRAND_LONG "\n\t"
> +		     "jc 2f\n\t"
> +		     "decl %0\n\t"
> +		     "jnz 1b\n\t"
> +		     "2:"
> +		     : "=r" (ok), "=a" (*v)
> +		     : "0" (RDRAND_RETRY_LOOPS));
> +	return ok;
> +}
> +

This looks just like rdrand_long() in arch/x86/kernel/cpu/rdrand.c and
could move into the header file, no?

	-hpa


