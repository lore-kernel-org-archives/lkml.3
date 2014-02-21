Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbaBUPII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:08:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:43499 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbaBUPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:08:06 -0500
Message-ID: <53076BDE.5000205@windriver.com>
Date: Fri, 21 Feb 2014 10:08:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <behanw@converseincode.com>, <rob@landley.net>, <rdunlap@infradead.org>,
        <geert@linux-m68k.org>
CC: <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>
Subject: Re: [PATCH] module: LLVMLinux: Fix section mismatch issues on alias
 usage
References: <1392956909-22715-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1392956909-22715-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-02-20 11:28 PM, behanw@converseincode.com wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
  ^^^^^^^^^^^^^^

This line implies that Jan is the author.

> 
> Attribute aliases don't inherit the link section name when compiled with clang.
> As a result, the linking section needs to be explicitly specified when building
> a module. This behavior is undefined in the standard which is why it differs from
> compiler to compiler.

But is there a good reason why clang doesn't inherit them in the
interest of compatibility with gcc and existing code?

> 
> Author:  PaX Team <pageexec@freemail.hu>
> ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
> URL:     http://llvm.linuxfoundation.org
> Merge:   Jan-Simon Möller <dl9pf@gmx.de>

I know we've seen the faceless entity "PaX Team" before, but can we
please not make it worse by adding a bunch of other non standard tag
line formats?  And ideally have a real human name for the author too.

Paul.
--

> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  include/linux/init.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> index e168880..384ec5e 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -297,13 +297,14 @@ void __init parse_early_options(char *cmdline);
>  #define module_init(initfn)					\
>  	static inline initcall_t __inittest(void)		\
>  	{ return initfn; }					\
> -	int init_module(void) __attribute__((alias(#initfn)));
> +	int init_module(void) __section(.init) __attribute__((alias(#initfn)));
>  
>  /* This is only required if you want to be unloadable. */
>  #define module_exit(exitfn)					\
>  	static inline exitcall_t __exittest(void)		\
>  	{ return exitfn; }					\
> -	void cleanup_module(void) __attribute__((alias(#exitfn)));
> +	void cleanup_module(void) __section(.exit)              \
> +		__attribute__((alias(#exitfn)));
>  
>  #define __setup_param(str, unique_id, fn)	/* nothing */
>  #define __setup(str, func) 			/* nothing */
> 
