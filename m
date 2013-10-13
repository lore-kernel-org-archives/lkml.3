Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3JMLJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 07:09:33 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52170 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab3JMLJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 07:09:32 -0400
Date: Sun, 13 Oct 2013 04:09:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matias Bjorling <m@bjorling.me>
Cc: tj@kernel.org, koverstreet@google.com, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu-refcount: Export symbols
Message-ID: <20131013110925.GD5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1381494492-1735-1-git-send-email-m@bjorling.me>
 <1381494492-1735-2-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381494492-1735-2-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101311-5806-0000-0000-0000230CDB39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:28:12PM +0200, Matias Bjorling wrote:
> Need to be exported for being used within modules.
> 
> Signed-off-by: Matias Bjorling <m@bjorling.me>

I will bite...  Why not EXPORT_SYMBOL_GPL()?

							Thanx, Paul

> ---
>  lib/percpu-refcount.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index 7deeb62..25b9ac7 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -53,6 +53,7 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release)
>  	ref->release = release;
>  	return 0;
>  }
> +EXPORT_SYMBOL(percpu_ref_init);
> 
>  /**
>   * percpu_ref_cancel_init - cancel percpu_ref_init()
> @@ -84,6 +85,7 @@ void percpu_ref_cancel_init(struct percpu_ref *ref)
>  		free_percpu(ref->pcpu_count);
>  	}
>  }
> +EXPORT_SYMBOL(percpu_ref_cancel_init);
> 
>  static void percpu_ref_kill_rcu(struct rcu_head *rcu)
>  {
> @@ -156,3 +158,4 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
> 
>  	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
>  }
> +EXPORT_SYMBOL(percpu_ref_kill_and_confirm);
> -- 
> 1.8.1.2
> 

