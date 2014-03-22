Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaCVQVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:21:54 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:46130 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaCVQVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:21:53 -0400
Date: Sat, 22 Mar 2014 17:21:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: behanw@converseincode.com
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] LLVMLinux: Remove warning about returning an
 uninitialized variable
Message-ID: <20140322162147.GA9034@ravnborg.org>
References: <201403221101.16961.arnd@arndb.de>
 <1395503299-15203-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395503299-15203-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 08:48:19AM -0700, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> Fix uninitialized return code in default case in cmpxchg-local.h
> 
> This patch fixes the code to prevent an uninitialized return value that is detected
> when compiling with clang. The bug produces numerous warnings when compiling the
> Linux kernel with clang.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> ---
>  include/asm-generic/cmpxchg-local.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
> index d8d4c89..9112111 100644
> --- a/include/asm-generic/cmpxchg-local.h
> +++ b/include/asm-generic/cmpxchg-local.h
> @@ -41,6 +41,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
>  		break;
>  	default:
>  		wrong_size_cmpxchg(ptr);
> +		__builtin_unreachable();

It is unreachable() - see compiler.h

	Sam
