Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3LQTYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:24:48 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44626 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3LQTYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:24:45 -0500
Date: Tue, 17 Dec 2013 11:24:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20131217192439.GD15969@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
 <1385147087-26588-5-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385147087-26588-5-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121719-6688-0000-0000-000004A243ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:04:47PM -0500, Waiman Long wrote:
> This patch modifies the queue_write_unlock() function to use the
> new smp_store_release() function in another pending patch. This patch
> should only be merged if the other patch was merged.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/asm-generic/qrwlock.h |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> index 335473a..59c5972 100644
> --- a/include/asm-generic/qrwlock.h
> +++ b/include/asm-generic/qrwlock.h
> @@ -176,9 +176,7 @@ static inline void queue_write_unlock(struct qrwlock *lock)
>  	/*
>  	 * Make sure that none of the critical section will be leaked out.
>  	 */
> -	smp_mb__before_clear_bit();
> -	ACCESS_ONCE(lock->cnts.writer) = 0;
> -	smp_mb__after_clear_bit();
> +	smp_store_release(&lock->cnts.writer, 0)
>  }
> 
>  /*
> -- 
> 1.7.1
> 

