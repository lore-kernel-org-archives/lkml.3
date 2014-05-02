Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaEBNKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbaEBNKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:10:33 -0400
Date: Fri, 2 May 2014 14:10:22 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: Jan Moskyto Matejka <mq@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [linux-next] watchdog: convert deprecated call to
 current interface
Message-ID: <20140502131022.GA20581@atomlin.usersys.redhat.com>
References: <1399035374-13548-1-git-send-email-mq@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399035374-13548-1-git-send-email-mq@suse.cz>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 02:56:14PM +0200, Jan Moskyto Matejka wrote:
> This commit fixes this warning:
> 
> kernel/watchdog.c: In function ‘watchdog_timer_fn’:
> kernel/watchdog.c:368:4: warning: ‘smp_mb__after_clear_bit’ is deprecated (declared at include/linux/bitops.h:48) [-Wdeprecated-declarations]
>     smp_mb__after_clear_bit();
> 
> That code was introduced in commit 90e6b763ca8a5eb739e59489f42d45e13431d157
> ("kernel/watchdog.c: print traces for all cpus on lockup detection") and then
> merged with another branch containing commit
> febdbfe8a91ce0d11939d4940b592eb0dba8d663 ("arch: Prepare for
> smp_mb__{before,after}_atomic()") which deprecates the
> smp_mb__after_clear_bit() call in favour of smp_mb__after_atomic().
> 
> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
> ---
>  kernel/watchdog.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 4dbc7f8..d977f51 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -365,7 +365,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  
>  			clear_bit(0, &soft_lockup_nmi_warn);
>  			/* Barrier to sync with other cpus */
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
>  		}
>  
>  		if (softlockup_panic) {
> -- 
> 1.8.4.5

Acked-by: Aaron Tomlin <atomlin@redhat.com>

-- 
Aaron Tomlin
