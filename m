Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbaFTQVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:21:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46703 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbaFTQVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:21:09 -0400
Message-ID: <53A45F5D.90505@zytor.com>
Date: Fri, 20 Jun 2014 09:20:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: bp@alien8.de, x86@kernel.org
Subject: Re: [RFC][PATCH 1/3] x86: introduce disabled-features
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
In-Reply-To: <20140620161736.D6AC16FD@viggo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 09:17 AM, Dave Hansen wrote:
> diff -puN /dev/null arch/x86/include/asm/disabled-features.h
> --- /dev/null	2014-04-10 11:28:14.066815724 -0700
> +++ b/arch/x86/include/asm/disabled-features.h	2014-06-20 09:15:38.968987152 -0700
> @@ -0,0 +1,33 @@
> +#ifndef _ASM_X86_DISABLED_FEATURES_H
> +#define _ASM_X86_DISABLED_FEATURES_H
> +
> +/* These features, although they might be available in a CPU
> + * will not be used because the compile options to support
> + * them are not present.
> + *
> + * This code allows them to be checked and disabled at
> + * compile time withut an explicit #ifdef.  Simply call
> + * cpu_has() or this_cpu_has().
> + * */
> +
> +#ifdef CONFIG_X86_INTEL_MPX
> +# define HAVE_MPX	(1<<(X86_FEATURE_MPX & 31))
> +#else
> +# define HAVE_MPX	0
> +#endif
> +

Is this an inverted test?

	-hpa

