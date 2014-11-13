Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbaKMULX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:11:23 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47733 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933468AbaKMULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:11:22 -0500
Date: Thu, 13 Nov 2014 12:11:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/16] doc: memory-barriers.txt: Document use of
 lockless_dereference()
Message-ID: <20141113201115.GR4460@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
 <1415906662-4576-3-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415906662-4576-3-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111320-0033-0000-0000-000002AE6334
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 02:24:08PM -0500, Pranith Kumar wrote:
> Recently lockless_dereference() was added which can be used in place of
> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  Documentation/memory-barriers.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 3d5f49b..841ac36 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -203,7 +203,7 @@ There are some minimal guarantees that may be expected of a CPU:
>       and always in that order.  On most systems, smp_read_barrier_depends()
>       does nothing, but it is required for DEC Alpha.  The ACCESS_ONCE()
>       is required to prevent compiler mischief.  Please note that you
> -     should normally use something like rcu_dereference() instead of
> +     should normally use something like lockless_dereference() instead of

Good catch, but please keep both possibilities, something like
"... like rcu_dereference() or lockless_dereference() instead of ..."

						Thanx, Paul

>       open-coding smp_read_barrier_depends().
> 
>   (*) Overlapping loads and stores within a particular CPU will appear to be
> -- 
> 1.9.1
> 

