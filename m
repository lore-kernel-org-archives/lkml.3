Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3KQVkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 16:40:13 -0500
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:33147 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752402Ab3KQVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 16:40:07 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3870:3872:3873:4321:4552:4559:4605:5007:6119:7652:8957:9010:9012:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12679:12740:13019:13069:13072:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: board78_3af6d32b8e95c
X-Filterd-Recvd-Size: 2669
Message-ID: <1384724403.2727.22.camel@joe-AO722>
Subject: Re: [PATCH] jffs2: fix sparse errors: directive in argument list
From: Joe Perches <joe@perches.com>
To: Erico Nunes <nunes.erico@gmail.com>, linux-sparse@vger.kernel.org
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sun, 17 Nov 2013 13:40:03 -0800
In-Reply-To: <1384719513-27386-1-git-send-email-nunes.erico@gmail.com>
References: <1384719513-27386-1-git-send-email-nunes.erico@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 18:18 -0200, Erico Nunes wrote:
> This patch fixes the following errors reported when running sparse:
> fs/jffs2/super.c:378:1: error: directive in argument list
> fs/jffs2/super.c:380:1: error: directive in argument list
> fs/jffs2/super.c:381:1: error: directive in argument list
> fs/jffs2/super.c:383:1: error: directive in argument list

Seems like a sparse error more than anything else.
(adding sparse mailing list)

Also you need to add a "Signed-off-by:" line
with your email address.

see: Documentation/SubmittingPatches

> ---
>  fs/jffs2/super.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
> index 0defb1c..ec9e16f 100644
> --- a/fs/jffs2/super.c
> +++ b/fs/jffs2/super.c
> @@ -361,6 +361,14 @@ MODULE_ALIAS_FS("jffs2");
>  static int __init init_jffs2_fs(void)
>  {
>  	int ret;
> +	const char desc[] = "version 2.2."
> +#ifdef CONFIG_JFFS2_FS_WRITEBUFFER
> +		" (NAND)"
> +#endif
> +#ifdef CONFIG_JFFS2_SUMMARY
> +		" (SUMMARY) "
> +#endif
> +		" © 2001-2006 Red Hat, Inc.";
>  
>  	/* Paranoia checks for on-medium structures. If we ask GCC
>  	   to pack them with __attribute__((packed)) then it _also_
> @@ -374,14 +382,7 @@ static int __init init_jffs2_fs(void)
>  	BUILD_BUG_ON(sizeof(struct jffs2_raw_inode) != 68);
>  	BUILD_BUG_ON(sizeof(struct jffs2_raw_summary) != 32);
>  
> -	pr_info("version 2.2."
> -#ifdef CONFIG_JFFS2_FS_WRITEBUFFER
> -	       " (NAND)"
> -#endif
> -#ifdef CONFIG_JFFS2_SUMMARY
> -	       " (SUMMARY) "
> -#endif
> -	       " © 2001-2006 Red Hat, Inc.\n");
> +	pr_info("%s\n", desc);
>  
>  	jffs2_inode_cachep = kmem_cache_create("jffs2_i",
>  					     sizeof(struct jffs2_inode_info),



