Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaAMTC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:02:28 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63042 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaAMTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:02:26 -0500
Date: Mon, 13 Jan 2014 20:02:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 1/2] rwsem: add rwsem_is_contended
Message-ID: <20140113190221.GA9667@gmail.com>
References: <1389633531-1921-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389633531-1921-1-git-send-email-jbacik@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josef Bacik <jbacik@fb.com> wrote:

> From: Josef Bacik <jbacik@fusionio.com>
> 
> Btrfs needs a simple way to know if it needs to let go of it's read lock on a
> rwsem.  Introduce rwsem_is_contended to check to see if there are any waiters on
> this rwsem currently.  This is just a hueristic, it is meant to be light and not
> 100% accurate and called by somebody already holding on to the rwsem in either
> read or write.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  include/linux/rwsem.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index 0616ffe..03f3b05 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -75,6 +75,17 @@ do {								\
>  } while (0)
>  
>  /*
> + * This is the same regardless of which rwsem implementation that is being used.
> + * It is just a heuristic meant to be called by somebody alreadying holding the
> + * rwsem to see if somebody from an incompatible type is wanting access to the
> + * lock.
> + */
> +static inline int rwsem_is_contended(struct rw_semaphore *sem)
> +{
> +	return !list_empty(&sem->wait_list);
> +}
> +
> +/*
>   * lock for reading
>   */
>  extern void down_read(struct rw_semaphore *sem);

Looks good to me. To make it easier to merge 2/2 feel free to add this 
to the BTRFS tree, with my Acked-by:

  Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
