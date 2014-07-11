Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaGKVNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:13:38 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:57962 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaGKVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:13:38 -0400
Message-ID: <1405113215.2500.19.camel@j-VirtualBox>
Subject: Re: [PATCH peterz-queue:locking/core 1/2] locking/rwsem: Fix
 building with opt spinning and new osq_lock header
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2014 14:13:35 -0700
In-Reply-To: <1405112406-13052-1-git-send-email-davidlohr@hp.com>
References: <1405112406-13052-1-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 14:00 -0700, Davidlohr Bueso wrote:
> Commit 'rwsem: Reduce the size of struct rw_semaphore' broke all
> DECLARE_RWSEM users, ie:
> 
> init/init_task.c:14:44: error: ‘OSQ_UNLOCKED_VA’ undeclared here (not in a function)
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  include/linux/rwsem.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index 0eff99c..5d40884 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
>  #endif
>  
>  #if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
> -#define __RWSEM_OPT_INIT(lockname)	, .owner = NULL, .osq = { ATOMIC_INIT(OQS_UNLOCKED_VAL) }
> +#define __RWSEM_OPT_INIT(lockname)	, .owner = NULL, .osq = { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }

Hi David, I'll be sending out a v2 patchset which address Steven's
feedback (which includes using a macro instead of directly initializing
the osq field).

Thanks!


