Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaFZS67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:58:59 -0400
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:51610 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197AbaFZS66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:58:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3876:3877:4321:5007:6114:6642:7652:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trees54_13abed993435b
X-Filterd-Recvd-Size: 1418
Message-ID: <1403809133.7977.63.camel@joe-AO725>
Subject: Re: [PATCH] ecryptfs: Drop cast
From: Joe Perches <joe@perches.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Thu, 26 Jun 2014 11:58:53 -0700
In-Reply-To: <20140626184233.GA4275@himangi-Dell>
References: <20140626184233.GA4275@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 00:12 +0530, Himangi Saraogi wrote:
> This patch does away with casts on void * as they are unnecessary.
[]
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
[]
> @@ -53,7 +53,7 @@ static void unlock_dir(struct dentry *dir)
>  
>  static int ecryptfs_inode_test(struct inode *inode, void *lower_inode)
>  {
> -	if (ecryptfs_inode_to_lower(inode) == (struct inode *)lower_inode)
> +	if (ecryptfs_inode_to_lower(inode) == lower_inode)
>  		return 1;
>  	return 0;
>  }

True, but perhaps this should be

{
	return ecryptfs_inode_to_lower(inode) == lower_inode;
}



