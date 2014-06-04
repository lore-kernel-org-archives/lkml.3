Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaFDU4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:56:52 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41341 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFDU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <538F83DF.8090303@gatech.edu>
References: <538F83DF.8090303@gatech.edu>
Date: Wed, 4 Jun 2014 16:56:50 -0400
Message-ID: <CAJUuVQ4VioKuVuCTXr3BcfRpYs+9+5bx9m2WLO7Swsnni0tUAw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] remove redundant compare, cmpxchg already does it
From: Andev <debiandev@gmail.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 4:38 PM, Pranith Kumar <pranith@gatech.edu> wrote:
> remove a redundant comparision
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/locking/rwsem-xadd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index 1f99664b..6f8bd3c 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -249,8 +249,7 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
>  {
>      if (!(count & RWSEM_ACTIVE_MASK)) {
>          /* try acquiring the write lock */
> -        if (sem->count == RWSEM_WAITING_BIAS &&
> -            cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> +        if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
>                  RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {

This was mainly done to avoid the cost of a cmpxchg in case where they
are not equal. Not sure if it really makes a difference though.

-- 
Andev
