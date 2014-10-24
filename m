Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaJXTNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:13:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:57971 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaJXTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:13:03 -0400
Message-ID: <544AA4BA.2040106@infradead.org>
Date: Fri, 24 Oct 2014 12:12:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@pefoley.com>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] vdso: don't require 64-bit math in standalone test
References: <544A9F1A.4050303@suse.com>
In-Reply-To: <544A9F1A.4050303@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/14 11:48, Jeff Mahoney wrote:
> The use of 64-bit math on i386 causes build failures:
> vdso_standalone_test_x86.c:(.text+0x101): undefined reference to `__umoddi3'
> vdso_standalone_test_x86.c:(.text+0x12d): undefined reference to `__udivdi3'
> 
> Commit adb19fb66ee (Documentation: add makefiles for more targets) is
> now building this by default, so it's failing the kernel build entirely.
> 
> Switching the declaration from uint64_t to time_t does the right thing
> and handles the x32 case automatically.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Jon, please pick this up.  It was
Acked-by: Peter Foley <pefoley2@pefoley.com>

> ---
>  Documentation/vDSO/vdso_standalone_test_x86.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/Documentation/vDSO/vdso_standalone_test_x86.c
> +++ b/Documentation/vDSO/vdso_standalone_test_x86.c
> @@ -63,7 +63,7 @@ static inline void linux_exit(int code)
>  	x86_syscall3(__NR_exit, code, 0, 0);
>  }
>  
> -void to_base10(char *lastdig, uint64_t n)
> +void to_base10(char *lastdig, time_t n)
>  {
>  	while (n) {
>  		*lastdig = (n % 10) + '0';
> 


-- 
~Randy
