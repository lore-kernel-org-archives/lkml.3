Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaBMGsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 01:48:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaBMGsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 01:48:30 -0500
Message-ID: <1392274106.28471.2.camel@marge.simpson.net>
Subject: Re: [PATCH] compiler/gcc4: make quirk for asm_volatile_goto
 unconditional
From: Mike Galbraith <bitbucket@online.de>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Feb 2014 07:48:26 +0100
In-Reply-To: <1392267191-6708-1-git-send-email-steven@uplinklabs.net>
References: <CA+55aFys_VK+q3LMRzEM-AKU-=fM_tgiDdLm2AO=jVfH7OvrHQ@mail.gmail.com>
	 <1392267191-6708-1-git-send-email-steven@uplinklabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:QCUO8aGxQSYvbO6cbFhPNsoo8P1aAgB4dgee3pzflkB
 7eSspvWIbpZQaQjxiXdFCzR/0C/iSgHCllIAtAjWsXEcRjz8CF
 heWXPnC4+K0MPdA89biJzwXWDjtburAlh8KDaCXGyD5OU4P65D
 3OTaxGrkhFMjU999pOWF62cguYVrhCBzh+1jFxiP2OB3zSjqro
 zZMeN2MsoJOl2lm5O6xWP13XIv0nGWTLJRYyDzm4zLr4Xc2eFj
 QlVGYthv4nYm9hPiXg/8hpbPYwjvEpGyY2wJoDWqRyK5EJzCwX
 piAhC12lXLL/LUxrBIc0Z17YQdhrnwCR/nfy0+SvAl2a76Wk1r
 qKfyg4w1G4j2g3Zi/3djrBtRA+/ArH15T61AWLNc51JoPQ/erR
 P9wQMWILoRYxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 20:53 -0800, Steven Noonan wrote: 
> I started noticing problems with KVM guest destruction on Linux 3.12+, where
> guest memory wasn't being cleaned up. I bisected it down to the commit
> introducing the new 'asm goto'-based atomics, and found this quirk was later
> applied to those.
> 
> Unfortunately, even with GCC 4.8.2 (which ostensibly fixed the known 'asm goto'
> bug) I am still getting some kind of miscompilation. If I enable the
> asm_volatile_goto quirk for my compiler, KVM guests are destroyed correctly and
> the memory is cleaned up.
> 
> [1] http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Cc: stable@vger.kernel.org v3.12+ ?

> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  include/linux/compiler-gcc4.h | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index ded4299..2507fd2 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -75,11 +75,7 @@
>   *
>   * (asm goto is automatically volatile - the naming reflects this.)
>   */
> -#if GCC_VERSION <= 40801
> -# define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
> -#else
> -# define asm_volatile_goto(x...)	do { asm goto(x); } while (0)
> -#endif
> +#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
>  
>  #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
>  #if GCC_VERSION >= 40400


