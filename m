Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaL1Qye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:54:34 -0500
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:60501 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751897AbaL1Qyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:54:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:3873:4321:5007:6261:7903:10004:10400:10848:11026:11232:11233:11658:11914:12043:12296:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: party42_619136b52890e
X-Filterd-Recvd-Size: 1883
Message-ID: <1419785668.20894.13.camel@perches.com>
Subject: Re: [PATCH 1/1] fs/ufs/super.c: remove unnecessary casting
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 28 Dec 2014 08:54:28 -0800
In-Reply-To: <1419780509-4582-1-git-send-email-fabf@skynet.be>
References: <1419780509-4582-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-28 at 16:28 +0100, Fabian Frederick wrote:
> Fix the following coccinelle warning:
> fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
> allocation function to (struct ufs_inode_info *) is useless.
[]
> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
[]
> @@ -1414,8 +1414,8 @@ static struct kmem_cache * ufs_inode_cachep;
>  
>  static struct inode *ufs_alloc_inode(struct super_block *sb)
>  {
> -	struct ufs_inode_info *ei;
> -	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
> +	struct ufs_inode_info *ei = kmem_cache_alloc(ufs_inode_cachep,
> +						     GFP_NOFS);

If you insist on the blank line after declaration style,
perhaps it's better to separate the declaration from
the alloc so the alloc is on a single line like:

static struct inode *ufs_alloc_inode(struct super_block *sb)
{
	struct ufs_inode_info *ei;

	ei = kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
	if (!ei)
		return NULL;

	ei->vfs_inode.i_version = 1;
	etc...


