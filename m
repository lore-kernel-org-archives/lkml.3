Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3CYDjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:39:10 -0400
Received: from ozlabs.org ([203.10.76.45]:34681 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab3CYDjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:39:08 -0400
From: Michael Neuling <mikey@neuling.org>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/29] tsx: Add generic noop macros for RTM intrinsics
In-reply-to: <1364001923-10796-2-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org> <1364001923-10796-2-git-send-email-andi@firstfloor.org>
Comments: In-reply-to Andi Kleen <andi@firstfloor.org>
   message dated "Fri, 22 Mar 2013 18:24:55 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 25 Mar 2013 14:39:05 +1100
Message-ID: <30418.1364182745@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen <ak@linux.intel.com>
> 
> Add generic noop macros (act like transaction aborted) for RTM.
> The main use case is an occasional _xtest() added to generic
> code, without needing ifdefs. On x86+RTM this will use
> real TSX instructions.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/rtm.h |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/rtm.h
> 
> diff --git a/include/linux/rtm.h b/include/linux/rtm.h

RTM == restricted transactional memory.  I don't understand why it's
"restricted" and why any other architecture else would call it that and
hence why Linux should call it that?

Can we just call it TM for transactional memory?  Each arch can then
have their own implementation and call it what they want.

> new file mode 100644
> index 0000000..887b221
> --- /dev/null
> +++ b/include/linux/rtm.h
> @@ -0,0 +1,15 @@
> +#ifndef _LINUX_RTM
> +#define _LINUX_RTM 1
> +
> +#ifdef CONFIG_RTM_LOCKS
> +#include <asm/rtm.h>
> +#else
> +/* Make transactions appear as always abort */
> +#define _XBEGIN_STARTED 0
> +#define _xbegin() 1
> +#define _xtest()  0
> +#define _xend()   do {} while (0)
> +#define _xabort(x) do {} while (0)

Similarly.. these are clearly x86 centric.  Can we just call them
tmbegin, tmtest, tm... etc?

Mikey

> +#endif
> +
> +#endif
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
