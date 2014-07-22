Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaGVAIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:08:15 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61707 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaGVAIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:08:13 -0400
Date: Mon, 21 Jul 2014 17:08:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup include/asm-generic/atomic.h
In-Reply-To: <1405985437-16631-1-git-send-email-maddy@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1407211707510.5825@chino.kir.corp.google.com>
References: <1405985437-16631-1-git-send-email-maddy@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Madhavan Srinivasan wrote:

> Commit 4b358e2206 "cleanup include/asm-generic/atomic.h" added
> comments for #else/#endif, but ended up adding same comment
> "BITS_PER_LONG == 64" on both sides. This patch fixes it.
> 

It's intentionally like that, it comments the condition for which the 
#endif is matched.

> Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> ---
>  include/asm-generic/atomic-long.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
> index b7babf0..a8434c6 100644
> --- a/include/asm-generic/atomic-long.h
> +++ b/include/asm-generic/atomic-long.h
> @@ -253,6 +253,6 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
>  #define atomic_long_xchg(v, new) \
>  	(atomic_xchg((atomic_t *)(v), (new)))
>  
> -#endif  /*  BITS_PER_LONG == 64  */
> +#endif  /*  BITS_PER_LONG != 64  */
>  
>  #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
