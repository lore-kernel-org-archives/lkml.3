Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaJTAmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:42:05 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:41437 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751851AbaJTAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:42:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3873:4321:5007:7652:7904:10004:10400:10848:11026:11473:11658:11914:12296:12438:12517:12519:12740:13019:13069:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fear97_68dfb26f1a155
X-Filterd-Recvd-Size: 1718
Message-ID: <1413765718.7076.3.camel@perches.com>
Subject: Re: [PATCH 1/2] binfmt_misc: add comments & debug logs
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Date: Sun, 19 Oct 2014 17:41:58 -0700
In-Reply-To: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
References: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-19 at 19:03 -0400, Mike Frysinger wrote:
> let's deploy extensive pr_debug markers at
> logical parse points, and add comments to the dense parsing logic.
[]
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
[]
> @@ -259,14 +270,17 @@ static char * check_special_flags (char * sfs, Node * e)
>  	while (cont) {
>  		switch (*p) {
>  			case 'P':
> +				pr_debug("register: flag: P (preserve argv0)");

Missing '\n' newline.
Can you please add them as appropriate?

>  				p++;
>  				e->flags |= MISC_FMT_PRESERVE_ARGV0;
>  				break;
>  			case 'O':
> +				pr_debug("register: flag: O (open binary)");

etc...

> @@ -292,6 +306,8 @@ static Node *create_entry(const char __user *buffer, size_t count)
>  	char *buf, *p;
>  	char del;
>  
> +	pr_debug("register: received %zu bytes", count);

etc...



