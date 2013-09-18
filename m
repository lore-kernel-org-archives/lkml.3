Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3IRNb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3IRNb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:31:57 -0400
Date: Wed, 18 Sep 2013 09:31:48 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Dan Duval <dan.duval@oracle.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] audit: fix endless wait in audit_log_start()
Message-ID: <20130918133148.GB13968@madcap2.tricolour.ca>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
 <20130918094817.18754.8847.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918094817.18754.8847.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 01:48:17PM +0400, Konstantin Khlebnikov wrote:
> After commit 829199197a430dade2519d54f5545c4a094393b8 audit emiters will block
> forever if userspace daemon cannot handle backlog. After the timeout waiting
> loop turns into busy loop and runs until daemon dies or returns back to work.
> This is minimal patch for that bug.

Thanks Konstantin,

This patch is in my patchset...

> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Luiz Capitulino <lcapitulino@redhat.com>
> Cc: Richard Guy Briggs <rgb@redhat.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Chuck Anderson <chuck.anderson@oracle.com>
> Cc: Dan Duval <dan.duval@oracle.com>
> Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
> ---
>  kernel/audit.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 91e53d0..7b0e23a 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1117,9 +1117,10 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>  
>  			sleep_time = timeout_start + audit_backlog_wait_time -
>  					jiffies;
> -			if ((long)sleep_time > 0)
> +			if ((long)sleep_time > 0) {
>  				wait_for_auditd(sleep_time);
> -			continue;
> +				continue;
> +			}
>  		}
>  		if (audit_rate_check() && printk_ratelimit())
>  			printk(KERN_WARNING
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
