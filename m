Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaFMUwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:52:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbaFMUwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:52:14 -0400
Date: Fri, 13 Jun 2014 16:52:05 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/audit.c: use ARRAY_SIZE instead of
 sizeof/sizeof[0]
Message-ID: <20140613205205.GA19353@madcap2.tricolour.ca>
References: <1401825910-8793-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401825910-8793-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/03, Fabian Frederick wrote:
> Use kernel.h definition.

Thanks Fabian, I'll queue it.

> Cc: Eric Paris <eparis@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  kernel/audit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 47845c5..48e6e5d 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -718,7 +718,7 @@ static int audit_set_feature(struct sk_buff *skb)
>  	struct audit_features *uaf;
>  	int i;
>  
> -	BUILD_BUG_ON(AUDIT_LAST_FEATURE + 1 > sizeof(audit_feature_names)/sizeof(audit_feature_names[0]));
> +	BUILD_BUG_ON(AUDIT_LAST_FEATURE + 1 > ARRAY_SIZE(audit_feature_names));
>  	uaf = nlmsg_data(nlmsg_hdr(skb));
>  
>  	/* if there is ever a version 2 we should handle that here */
> -- 
> 1.8.4.5

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
