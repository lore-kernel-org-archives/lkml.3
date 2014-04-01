Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaDAUty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:49:54 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57801 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaDAUtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:49:53 -0400
Message-ID: <1396385391.23763.30.camel@x220>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: Paul Bolle <pebolle@tiscali.nl>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ak@linux.intel.com,
        gleb@redhat.com, hpa@zytor.com, hubicka@ucw.cz,
        linux-kernel@vger.kernel.org, mingo@kernel.org, pbonzini@redhat.com,
        perex@perex.cz, peterz@infradead.org, rostedt@goodmis.org,
        rusty@rustcorp.com.au, tglx@linutronix.de
Date: Tue, 01 Apr 2014 22:49:51 +0200
In-Reply-To: <201403312105.s2VL5AqX010173@terminus.zytor.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2014 20:49:52.0253 (UTC) FILETIME=[EDFDF2D0:01CF4DEB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 14:05 -0700, H. Peter Anvin wrote:
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -163,6 +163,23 @@ extern bool initcall_debug;
>  
>  #ifndef __ASSEMBLY__
>  
> +#ifdef CONFIG_LTO

I can't find a Kconfig symbol LTO nor a preprocessor define for
CONFIG_LTO. (I only checked master of Linus's tree and linux-next.)

Why is this check for CONFIG_LTO needed?

> +/* Work around a LTO gcc problem: when there is no reference to a variable
> + * in a module it will be moved to the end of the program. This causes
> + * reordering of initcalls which the kernel does not like.
> + * Add a dummy reference function to avoid this. The function is
> + * deleted by the linker.
> + */
> +#define LTO_REFERENCE_INITCALL(x) \
> +	; /* yes this is needed */			\
> +	static __used __exit void *reference_##x(void)	\
> +	{						\
> +		return &x;				\
> +	}
> +#else
> +#define LTO_REFERENCE_INITCALL(x)
> +#endif


Paul Bolle

