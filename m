Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaICJ1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:27:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:38868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaICJ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:27:28 -0400
Date: Wed, 3 Sep 2014 11:27:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/26] locking: Add non-fatal spin lock assert
Message-ID: <20140903092723.GA4783@worktop.ger.corp.intel.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1409693975-1028-14-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409693975-1028-14-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 05:39:22PM -0400, Peter Hurley wrote:
> Provide method for non-essential or non-critical code to warn of
> invariant errors.
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  include/linux/spinlock.h         | 1 +
>  include/linux/spinlock_api_smp.h | 1 +
>  include/linux/spinlock_api_up.h  | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index 3f2867f..8a9aaf1 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -394,6 +394,7 @@ static inline int spin_can_lock(spinlock_t *lock)
>  }
>  
>  #define assert_spin_locked(lock)	assert_raw_spin_locked(&(lock)->rlock)
> +#define warn_not_spin_locked(lock)	warn_not_raw_spin_locked(&(lock)->rlock)
>  
>  /*
>   * Pull the atomic_t declaration:
> diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
> index 42dfab8..0ddd499 100644
> --- a/include/linux/spinlock_api_smp.h
> +++ b/include/linux/spinlock_api_smp.h
> @@ -18,6 +18,7 @@
>  int in_lock_functions(unsigned long addr);
>  
>  #define assert_raw_spin_locked(x)	BUG_ON(!raw_spin_is_locked(x))
> +#define warn_not_raw_spin_locked(x)	WARN_ON_ONCE(!raw_spin_is_locked(x))

No we should remove assert_spin_locked() not add to it. Use
lockdep_assert_held() instead.
