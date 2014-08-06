Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaHFV4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:56:24 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58888 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaHFV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:56:22 -0400
Date: Wed, 6 Aug 2014 14:56:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bart Van Assche <bvanassche@acm.org>
cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] spin_lock_nested(): Always evaluate second argument
In-Reply-To: <53E2618F.6040208@acm.org>
Message-ID: <alpine.DEB.2.02.1408061455290.13545@chino.kir.corp.google.com>
References: <53CE1019.10708@acm.org> <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org> <alpine.DEB.2.02.1407221612330.10592@chino.kir.corp.google.com> <53E260D9.6030803@acm.org> <53E2618F.6040208@acm.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Bart Van Assche wrote:

> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index 3f2867f..485d5dc 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -197,7 +197,8 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
>  		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
>  	 } while (0)
>  #else
> -# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
> +# define raw_spin_lock_nested(lock, subclass)		\
> +	((void)(subclass), _raw_spin_lock(lock))
>  # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
>  #endif
>  

I think it would be nice to comment why we're evaluating the subclass when 
CONFIG_DEBUG_LOCK_ALLOC=n so that nobody comes along and unknowingly 
changes it back.

Thanks for posting the updated version and keeping at it!
