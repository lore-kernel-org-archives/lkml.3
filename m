Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab3HNVvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:51:37 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55603 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab3HNVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:51:36 -0400
Message-ID: <520BFBE4.4040807@gmail.com>
Date: Wed, 14 Aug 2013 14:51:32 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: behanw@converseincode.com
CC: linux@arm.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, charlebm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: LLVMLinux: Change "extern inline" to "gnu_inline"
 in ARM ftrace.h
References: <1376516261-2071-1-git-send-email-behanw@converseincode.com> <1376516261-2071-2-git-send-email-behanw@converseincode.com>
In-Reply-To: <1376516261-2071-2-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 02:37 PM, behanw@converseincode.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
>
> With compilers which follow the C99 standard (like modern versions of gcc and
> clang), "extern inline" does the wrong thing (emits code for an externally
> linkable version of the inline function). In this case using the gnu_inline
> attribute makes inline do the right thing on gcc and on clang.
>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>   arch/arm/include/asm/ftrace.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> index f89515a..fb7fdc4 100644
> --- a/arch/arm/include/asm/ftrace.h
> +++ b/arch/arm/include/asm/ftrace.h
> @@ -45,7 +45,8 @@ void *return_address(unsigned int);
>
>   #else
>
> -extern inline void *return_address(unsigned int level)
> +extern inline __attribute__((gnu_inline))

That seems very ugly.

Is it possible to put something in linux/compiler.h that encapsulates 
the desired semantics, and then use that instead?

We already define "inline" that way, if you need something else, put it 
in compiler.h with a nice symbolic name, and then use it.


> +void *return_address(unsigned int level)
>   {
>   	return NULL;
>   }
>

