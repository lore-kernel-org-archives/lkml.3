Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaCEW1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:27:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbaCEW1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:27:06 -0500
Date: Wed, 5 Mar 2014 17:27:03 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: remove stray newlines from audit_log_lost messages
Message-ID: <20140305222703.GW16640@madcap2.tricolour.ca>
References: <20140305212955.GV6301@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305212955.GV6301@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/05, Josh Boyer wrote:
> Calling audit_log_lost with a \n in the format string leads to extra
> newlines in dmesg.  That function will eventually call audit_panic which
> uses pr_err with an explicit \n included.  Just make these calls match the
> others that lack \n.
> 
> Reported-by: Jonathan Kamens <jik@kamens.brookline.ma.us>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Ack.  queued.

> ---
>  kernel/audit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 34c5a23..f6bce4d 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -396,7 +396,7 @@ static void audit_printk_skb(struct sk_buff *skb)
>  		if (printk_ratelimit())
>  			pr_notice("type=%d %s\n", nlh->nlmsg_type, data);
>  		else
> -			audit_log_lost("printk limit exceeded\n");
> +			audit_log_lost("printk limit exceeded");
>  	}
>  
>  	audit_hold_skb(skb);
> @@ -412,7 +412,7 @@ static void kauditd_send_skb(struct sk_buff *skb)
>  		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
>  		if (audit_pid) {
>  			pr_err("*NO* daemon at audit_pid=%d\n", audit_pid);
> -			audit_log_lost("auditd disappeared\n");
> +			audit_log_lost("auditd disappeared");
>  			audit_pid = 0;
>  			audit_sock = NULL;
>  		}
> -- 
> 1.8.5.3

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
