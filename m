Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab3HNV4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:56:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38047 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933121Ab3HNV4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:56:11 -0400
Message-ID: <1376517370.1949.115.camel@joe-AO722>
Subject: Re: [PATCH] ARM: LLVMLinux: Change "extern inline" to "gnu_inline"
 in ARM ftrace.h
From: Joe Perches <joe@perches.com>
To: behanw@converseincode.com
Cc: linux@arm.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, charlebm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 14 Aug 2013 14:56:10 -0700
In-Reply-To: <1376516261-2071-2-git-send-email-behanw@converseincode.com>
References: <1376516261-2071-1-git-send-email-behanw@converseincode.com>
	 <1376516261-2071-2-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 17:37 -0400, behanw@converseincode.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
> 
> With compilers which follow the C99 standard (like modern versions of gcc and
> clang), "extern inline" does the wrong thing (emits code for an externally
> linkable version of the inline function). In this case using the gnu_inline
> attribute makes inline do the right thing on gcc and on clang.

Why not convert these to static inline?

> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
[]
> @@ -45,7 +45,8 @@ void *return_address(unsigned int);
>  
>  #else
>  
> -extern inline void *return_address(unsigned int level)
> +extern inline __attribute__((gnu_inline))
> +void *return_address(unsigned int level)
>  {
>  	return NULL;
>  }



