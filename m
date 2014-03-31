Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaCaUxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:53:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbaCaUxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:53:31 -0400
Message-ID: <5339D57A.4050504@zytor.com>
Date: Mon, 31 Mar 2014 13:52:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: behanw@converseincode.com, arnd@arndb.de
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] LLVMLinux: Remove warning about returning an uninitialized
 variable
References: <1395470329-15065-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1395470329-15065-1-git-send-email-behanw@converseincode.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:38 PM, behanw@converseincode.com wrote:
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
> index d8d4c89..4c41bb8 100644
> --- a/include/asm-generic/cmpxchg-local.h
> +++ b/include/asm-generic/cmpxchg-local.h
> @@ -41,6 +41,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
>  		break;
>  	default:
>  		wrong_size_cmpxchg(ptr);
> +		prev = 0;
>  	}
>  	raw_local_irq_restore(flags);
>  	return prev;
> 

Shouldn't this be a build time assert (__compiletime_error())?

	-hpa

