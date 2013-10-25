Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3JYSdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:33:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab3JYSdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:33:36 -0400
Date: Fri, 25 Oct 2013 14:33:24 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: remove useless code in audit_enable
Message-ID: <20131025183324.GD5059@madcap2.tricolour.ca>
References: <1382583594-5426-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382583594-5426-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 10:59:54AM +0800, Gao feng wrote:
> Since kernel parameter is operated before
> initcall, so the audit_initialized must be
> AUDIT_UNINITIALIZED or DISABLED in audit_enable.

Looks good, but should convert "printk(KERN_INFO " to "pr_info(".

> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  kernel/audit.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 50fdcba..b7269a4 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -927,17 +927,8 @@ static int __init audit_enable(char *str)
>  	if (!audit_default)
>  		audit_initialized = AUDIT_DISABLED;
>  
> -	printk(KERN_INFO "audit: %s", audit_default ? "enabled" : "disabled");
> -
> -	if (audit_initialized == AUDIT_INITIALIZED) {
> -		audit_enabled = audit_default;
> -		audit_ever_enabled |= !!audit_default;
> -	} else if (audit_initialized == AUDIT_UNINITIALIZED) {
> -		printk(" (after initialization)");
> -	} else {
> -		printk(" (until reboot)");
> -	}
> -	printk("\n");
> +	printk(KERN_INFO "audit: %s\n", audit_default ?
> +		"enabled (after initialization)" : "disabled (until reboot)");
>  
>  	return 1;
>  }

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
