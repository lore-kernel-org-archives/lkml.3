Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaD1UNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:13:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47583 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbaD1UNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:13:08 -0400
Date: Mon, 28 Apr 2014 13:13:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] rcutorture: don't mark torture_init_{begin,end} with
 __init
Message-ID: <20140428201304.GI4430@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1398711815-22153-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398711815-22153-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042820-3532-0000-0000-0000015E0478
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 08:03:35PM +0100, Will Deacon wrote:
> By the time rcutorture is initialised via its module_init callback, the
> .init.text section of torture.ko has already been freed, so the calls to
> torture_init{begin,end} end up branching to junk.
> 
> This patch removes the __init annotations from torture_init_{begin,end}
> to make sure the code is there when we want to call it.
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Good catch, and apologies for the wasted day, but someone beat you to
this.  By only 12 days, which is a bit surprising given how long this
has been lurking.

							Thanx, Paul

> ---
> 
> Just lost a day to this -- I was sure my static relocation handling must
> be to blame!
> 
>  kernel/torture.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/torture.c b/kernel/torture.c
> index acc9afc2f26e..d5ef30ce6eb5 100644
> --- a/kernel/torture.c
> +++ b/kernel/torture.c
> @@ -596,7 +596,7 @@ static void torture_stutter_cleanup(void)
>   * The runnable parameter points to a flag that controls whether or not
>   * the test is currently runnable.  If there is no such flag, pass in NULL.
>   */
> -void __init torture_init_begin(char *ttype, bool v, int *runnable)
> +void torture_init_begin(char *ttype, bool v, int *runnable)
>  {
>  	mutex_lock(&fullstop_mutex);
>  	torture_type = ttype;
> @@ -610,7 +610,7 @@ EXPORT_SYMBOL_GPL(torture_init_begin);
>  /*
>   * Tell the torture module that initialization is complete.
>   */
> -void __init torture_init_end(void)
> +void torture_init_end(void)
>  {
>  	mutex_unlock(&fullstop_mutex);
>  	register_reboot_notifier(&torture_shutdown_nb);
> -- 
> 1.9.2
> 

