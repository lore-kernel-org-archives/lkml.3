Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaGWSBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:01:43 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:52322 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbaGWSBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:01:41 -0400
Date: Wed, 23 Jul 2014 14:01:38 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        David Teigland <teigland@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] dlm: plock: Reduce indentation by rearranging order
Message-ID: <20140723140138.4ac10979@tlielax.poochiereds.net>
In-Reply-To: <f0e69e54dd8036834e47ccfafc3b8b06060f3ef1.1405879494.git.joe@perches.com>
References: <cover.1405879494.git.joe@perches.com>
	<f0e69e54dd8036834e47ccfafc3b8b06060f3ef1.1405879494.git.joe@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2014 11:23:42 -0700
Joe Perches <joe@perches.com> wrote:

> if blocks that have a goto at the end of one branch can be
> simplified by reordering and unindenting.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/dlm/plock.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
> index e0ab3a9..3e0b6fc 100644
> --- a/fs/dlm/plock.c
> +++ b/fs/dlm/plock.c
> @@ -144,23 +144,23 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
>  
>  	send_op(op);
>  
> -	if (xop->callback == NULL) {
> -		rv = wait_event_killable(recv_wq, (op->done != 0));
> -		if (rv == -ERESTARTSYS) {
> -			log_debug(ls, "dlm_posix_lock: wait killed %llx",
> -				  (unsigned long long)number);
> -			spin_lock(&ops_lock);
> -			list_del(&op->list);
> -			spin_unlock(&ops_lock);
> -			kfree(xop);
> -			do_unlock_close(ls, number, file, fl);
> -			goto out;
> -		}
> -	} else {
> +	if (xop->callback) {
>  		rv = FILE_LOCK_DEFERRED;
>  		goto out;
>  	}
>  
> +	rv = wait_event_killable(recv_wq, (op->done != 0));
> +	if (rv == -ERESTARTSYS) {
> +		log_debug(ls, "dlm_posix_lock: wait killed %llx",
> +			  (unsigned long long)number);
> +		spin_lock(&ops_lock);
> +		list_del(&op->list);
> +		spin_unlock(&ops_lock);
> +		kfree(xop);
> +		do_unlock_close(ls, number, file, fl);
> +		goto out;
> +	}
> +
>  	spin_lock(&ops_lock);
>  	if (!list_empty(&op->list)) {
>  		log_error(ls, "dlm_posix_lock: op on list %llx",

Looks right.

Reviewed-by: Jeff Layton <jlayton@poochiereds.net>
