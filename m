Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab3HNWvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:51:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41675 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab3HNWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:51:33 -0400
Date: Wed, 14 Aug 2013 23:45:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: behanw@converseincode.com
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        charlebm@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: LLVMLinux: Change "extern inline" to "gnu_inline"
	in ARM ftrace.h
Message-ID: <20130814224552.GA23006@n2100.arm.linux.org.uk>
References: <1376516261-2071-1-git-send-email-behanw@converseincode.com> <1376516261-2071-2-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376516261-2071-2-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 05:37:41PM -0400, behanw@converseincode.com wrote:
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
>  arch/arm/include/asm/ftrace.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> index f89515a..fb7fdc4 100644
> --- a/arch/arm/include/asm/ftrace.h
> +++ b/arch/arm/include/asm/ftrace.h
> @@ -45,7 +45,8 @@ void *return_address(unsigned int);
>  
>  #else
>  
> -extern inline void *return_address(unsigned int level)
> +extern inline __attribute__((gnu_inline))
> +void *return_address(unsigned int level)

Well, that should be static inline, not extern inline in any case.  Does
clang work if that's static inline?
