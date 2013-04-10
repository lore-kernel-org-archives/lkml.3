Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936304Ab3DJUJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:09:01 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59710 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935970Ab3DJUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:09:00 -0400
Date: Wed, 10 Apr 2013 16:08:55 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Message-ID: <407910335.12018469.1365624535873.JavaMail.root@redhat.com>
In-Reply-To: <51653645.90401@asianux.com>
References: <51653645.90401@asianux.com>
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: kernel: auditfilter: looping issue, memory leak if has 2 or more AUDIT_FILTERKEYs
Thread-Index: 3BeKkYef8KpORrjPWhkIucUSbQEZfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only allow one filter key per rule.  So we should never be able to get into this situation.  See audit_data_to_entry()

-Eric

----- Original Message -----
> 
>   in the 'fcount' looping,
>     if 'new->fields[*].type" has 2 or more AUDIT_FILTERKEYs
>     need judge new->filterkey whether has value, or memory leak.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/auditfilter.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index f9fc54b..936ac79 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -859,6 +859,8 @@ struct audit_entry *audit_dupe_rule(struct audit_krule
> *old)
>  						       &old->fields[i]);
>  			break;
>  		case AUDIT_FILTERKEY:
> +			if (new->filterkey)
> +				break;
>  			fk = kstrdup(old->filterkey, GFP_KERNEL);
>  			if (unlikely(!fk))
>  				err = -ENOMEM;
> --
> 1.7.7.6
> 
