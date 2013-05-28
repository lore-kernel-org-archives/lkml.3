Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3E1KOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3E1KOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:14:45 -0400
Date: Tue, 28 May 2013 06:14:35 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: Re: [54/94] sunrpc: clarify comments on rpc_make_runnable
Message-ID: <20130528061435.0e1b1cc4@corrin.poochiereds.net>
In-Reply-To: <lsq.1369712993.690390643@decadent.org.uk>
References: <lsq.1369712992.755341692@decadent.org.uk>
	<lsq.1369712993.690390643@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013 04:49:53 +0100
Ben Hutchings <ben@decadent.org.uk> wrote:

> 3.2.46-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jeff Layton <jlayton@redhat.com>
> 
> commit 506026c3ec270e18402f0c9d33fee37482c23861 upstream.
> 
> rpc_make_runnable is not generally called with the queue lock held, unless
> it's waking up a task that has been sitting on a waitqueue. This is safe
> when the task has not entered the FSM yet, but the comments don't really
> spell this out.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  net/sunrpc/sched.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/net/sunrpc/sched.c
> +++ b/net/sunrpc/sched.c
> @@ -296,8 +296,9 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_complet
>  /*
>   * Make an RPC task runnable.
>   *
> - * Note: If the task is ASYNC, this must be called with
> - * the spinlock held to protect the wait queue operation.
> + * Note: If the task is ASYNC, and is being made runnable after sitting on an
> + * rpc_wait_queue, this must be called with the queue spinlock held to protect
> + * the wait queue operation.
>   */
>  static void rpc_make_runnable(struct rpc_task *task)
>  {
> 

Just a comment patch, so this is harmless and I have no objection but
why pull it into stable? I had always thought stable-kernel-rules.txt
discouraged taking patches that don't fix real bugs...

-- 
Jeff Layton <jlayton@redhat.com>
